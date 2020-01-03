//
//  AssetManager.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 01/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit


open class AssetManager:NSObject{
    
    private var downloader:AssetDownloaderProtocol!
    var mainCache = AssetCache.main
    
    
    public typealias Operation = () -> Void
    public typealias ImageCompletionHandler = (UIImage?,Error?)->Void
    private lazy var retainedSortedCodableItems:Array<Codable> = []
    func performOnManQueue(_ block:@escaping Operation){
        DispatchQueue.main.async {block()}
    }
    
    var currentTasks:[Int:AssetDownloaderTaskProtocol] = [:]
    
    public init(with cache:AssetCache? = nil) {
        super.init()
        let session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: .current)
        downloader = AssetDownloader(session: session)
        if let cache = cache{
            mainCache = cache
        }
    }
    
    internal init(with cache:AssetCache? = nil, downloader:AssetDownloaderProtocol){
        super.init()
        self.downloader = downloader
       if let cache = cache{
           mainCache = cache
       }
    }
    
    func getFromCache(_ key:String)->Data?{
        return mainCache.getObject(for: key)?.value
    }
    
    /// Used For Downloading UIImage
    /// - Parameters:
    ///  - url: url of the data to be downloaded
    ///  -  completion: Completion blocked passes in the codable type if any and an optional error
    
    public func downloadImage(for url:URL, completion:@escaping (UIImage?,Error?)->Void){
        if let data = getFromCache(url.absoluteString){
            completion(UIImage(data: data),nil)
        }
        downloader.download(from: url) {[weak self] result in
            guard let self = self else {return}
            self.resolve(url: url, result: result, completion: completion)
        }
    }
    
    /// Used For Downloading UIImage
    /// - Parameters:
    ///  - url: url of the data to be downloaded
    ///  - identifier:Int A specified id for the download. Helpful for resuming after cancellation
    ///  -  completion: Completion blocked passes in the codable type if any and an optional error
    
    public func downloadImage(for url:URL, identifier:Int, completion:@escaping ImageCompletionHandler){
        if let data = getFromCache(url.absoluteString){
            completion(UIImage(data: data),nil)
            return
        }
        if let task = currentTasks[identifier] as? AssetDownloadTask{
            resumeDownloadFor(task: task, url: url, completion: completion)
            return
        }
        let task = downloader.download(from: url) {[weak self] result in
            guard let self = self else {return}
            self.currentTasks.removeValue(forKey: identifier)
            
        }
        currentTasks.updateValue(task, forKey: identifier)
    }
    
    
    func resolve(url:URL, result:AssetResult, completion:@escaping ImageCompletionHandler){
        switch result{
        case .failure(let err):
            AssetLoaderLogger.log(err: err, in: #function)
            self.performOnManQueue {completion(nil,err)}
            break
        case .success(let data):
            self.mainCache.set(object: data, for: url.absoluteString)
            let image = UIImage(data: data)
            self.performOnManQueue {completion(image,nil)}
        }
    }
    
    func resumeDownloadFor(task:AssetDownloadTask, url:URL, completion:@escaping ImageCompletionHandler){
        downloader.resumeDownload(with: task) {[weak self] result in
            self?.resolve(url:url, result: result, completion: completion)
        }
    }
    
    
    /// Used For Downloading Any Data Type that has *Codable* conformance
    /// - Parameters:
    ///  - url: url of the data to be downloaded
    ///  - type: The Explicit type of the Codable Data Type
    ///  -  completion: Completion blocked passes in the codable type if any and an optional error
    public func download<AnyCodable:Codable>(from url:URL,for type:AnyCodable.Type, completion:@escaping (AnyCodable?, Error?) -> Void){
        if let data = getFromCache(url.absoluteString){
            do {
                let decoder = JSONDecoder()
                let codable = try decoder.decode(type, from: data)
                completion(codable,nil)
            } catch let err {
                AssetLoaderLogger.log(err: err, in: #function)
                completion(nil,err)
            }
        }else{
            downloader.download(from: url) {[weak self] result in
                guard let self = self else {return}
                switch result{
                case .failure(let err):
                    AssetLoaderLogger.log(err: err, in:#function)
                    self.performOnManQueue {completion(nil,err)}
                    break
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let codable = try decoder.decode(type, from: data)
                        self.performOnManQueue {completion(codable,nil)}
                        self.mainCache.set(object: data, for: url.absoluteString)
                    } catch let err {
                        self.performOnManQueue {completion(nil,err)}
                    }
                }
            }
        }
    }
    
    /// Used For Downloading Any Data Type that has *Codable* conformance
    /// - Parameters:
    ///  - url: url of the data to be downloaded
    ///  - type: The Explicit type of the Codable Data Type
    ///  - cursor: A Cursor for sorting and fetching data in batches. Defaults to nil, all data is return instead
    ///  -  completion: Completion blocked passes in the codable type if any and an optional error
    public func download<AnyCodable:Codable>(from url:URL,for type:AnyCodable.Type,with cursor:Cursor, completion:@escaping (AnyCodable?, Error?) -> Void){
        if !retainedSortedCodableItems.isEmpty && cursor.range.upperBound < retainedSortedCodableItems.count{
            completion(retainedSortedCodableItems[cursor.startIndex..<cursor.endIndex] as? AnyCodable, nil)
            return
        }
        if let data = getFromCache(url.absoluteString){
            do {
                let decoder = JSONDecoder()
                let codable = try decoder.decode(type, from: data)
                self.finishCompletion(cursor: cursor, from: codable, completion: completion)
            } catch let err {
                AssetLoaderLogger.log(err: err, in: #function)
                completion(nil,err)
            }
        }else{
            downloader.download(from: url) {[weak self] result in
                guard let self = self else {return}
                switch result{
                case .failure(let err):
                    AssetLoaderLogger.log(err: err, in:#function)
                    self.performOnManQueue {completion(nil,err)}
                    break
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let codable = try decoder.decode(type, from: data)
                        
                        self.finishCompletion(cursor: cursor, from: codable, completion: completion)
                        self.mainCache.set(object: data, for: url.absoluteString)
                    } catch let err {
                        self.performOnManQueue {completion(nil,err)}
                    }
                }
            }
        }
    }
    
    
    func finishCompletion<AnyCodable:Codable>(cursor:Cursor, from bulkData:AnyCodable, completion:@escaping (AnyCodable?, Error?) -> Void){
        
        guard let data = getDatawith(cursor: cursor, from: bulkData) else {
            performOnManQueue {completion(nil,nil)}
            return
        }
        performOnManQueue {completion(data,nil)}
    }
    
    
    func getDatawith<AnyCodable:Codable>(cursor:Cursor,from bulkData:AnyCodable)->AnyCodable?{
        guard let bulk = bulkData as? Array<Codable> else {return bulkData}
        let sorted =  bulk.sorted {return cursor.sortOrder($0,$1)}
        retainedSortedCodableItems = sorted
        if cursor.range.endIndex < sorted.count{
            let start = cursor.range.startIndex
            let end = cursor.range.endIndex
            if let result = Array(sorted[start..<end]) as? AnyCodable{
                return result
            }else{
              return nil
            }
        }else{
            guard cursor.range.startIndex < sorted.count else {return nil }
            if let result = sorted[cursor.range.startIndex...] as? AnyCodable{
                return result
            }
            return nil
        }
    }
    
    /// Used For Downloading Images From multiple Sources in parallel
    /// - Parameters:
    ///  - urls: Array of urls to download from
    ///  -  completion: Completion blocked called each time a url in the urls array returns an image
    ///  - finalCompletion: Notifies caller that all operations for the url has been executed
    
    public func downloadMultipleImages(urls:[URL],completion:@escaping (URL,UIImage?) -> Void, finalCompletion:Operation? = nil){
        let group = DispatchGroup()
        if let final = finalCompletion{
            group.notify(queue: .main, execute: final)
        }
        urls.forEach { url in
            group.enter()
            downloadImage(for:url) {[weak self] image, _ in
                guard let self = self else {return}
                self.performOnManQueue {completion(url,image)}
                group.leave()
            }
        }
        
    }
    
    public func cancel(for identifier:Int){
        if let task = currentTasks[identifier]{
            task.cancel()
        }
    }
    
}


extension AssetManager:URLSessionDataDelegate{
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let url = dataTask.originalRequest?.url,let current = currentTasks as? [Int:AssetDownloadTask], let task = current.first(where: {($1).task.originalRequest?.url == url}) else{return}
        task.value.resumeData.append(data)
    }
}
