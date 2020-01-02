//
//  AssetManager.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 01/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit


class AssetManager{
    
    let downloader:AssetDownloader = AssetDownloader()
    let mainCache = AssetCache.main
    
    typealias Operation = () -> Void
    
    func performOnManQueue(_ block:@escaping Operation){
        DispatchQueue.main.async {block()}
    }
    
    public init() {
       
    }
    
    func getFromCache(_ key:String)->Data?{
        return mainCache.getObject(for: key)?.value
    }
    
    public func downloadImage(for url:URL, completion:@escaping (UIImage?,Error?)->Void){
        if let data = getFromCache(url.absoluteString){
            completion(UIImage(data: data),nil)
        }
        downloader.download(from: url) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .failure(let err):
                self.performOnManQueue {completion(nil,err)}
                break
            case .success(let data):
                self.mainCache.set(object: data, for: url.absoluteString)
                let image = UIImage(data: data)
                self.performOnManQueue {completion(image,nil)}
            }
        }
    }
    
    func download<AnyCodable:Codable>(from url:URL,for type:AnyCodable.Type,    completion:@escaping (AnyCodable?, Error?) -> Void){
        if let data = getFromCache(url.absoluteString){
            do {
                let decoder = JSONDecoder()
                let codable = try decoder.decode(type, from: data)
                completion(codable,nil)
            } catch let err {
                completion(nil,err)
            }
        }else{
            downloader.download(from: url) {[weak self] result in
                guard let self = self else {return}
                switch result{
                case .failure(let err):
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
    
    
}
