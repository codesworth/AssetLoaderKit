//
//  AssetDownloader.swift
//  AssetLoaderKit
//
//  Created by Shadrach Mensah on 01/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation

class AssetDownloader{
    
    typealias AssetResult = Result<Data,NetworkError>
    typealias AssetDownloadCompletionHandler = (AssetResult) -> ()
    
    let session:URLSession
    
    init() {
        session = URLSession(configuration: .ephemeral)
    }
    
    @discardableResult
    func download(from url:URL,completion:@escaping AssetDownloadCompletionHandler)->AssetDownloadTask{
        let request = URLRequest(url: url)
        
        let dataTask = session.downloadTask(with: request) { (url, _, err) in
            guard let url = url else {
                completion(.failure(NetworkError(err)))
                return
            }
            do{
                let data = try Data(contentsOf: url)
                completion(.success(data))
            }catch let err{
                completion(.failure(NetworkError(err)))
            }
        }
        let task = AssetDownloadTask(task: dataTask)
        task.resume()
        return task
    }
    
    func resumeDownload(with task:AssetDownloadTask, completion:@escaping AssetDownloadCompletionHandler){
        let data = task.resumeData
        session.downloadTask(withResumeData: data) { (url, _, err) in
            guard let url = url else {
                completion(.failure(NetworkError(err)))
                return
            }
            do{
                let data = try Data(contentsOf: url)
                completion(.success(data))
            }catch let err{
                completion(.failure(NetworkError(err)))
            }
        }
    }
}




