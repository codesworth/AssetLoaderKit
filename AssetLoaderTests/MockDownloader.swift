//
//  MockDownloader.swift
//  AssetLoaderTests
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation
@testable import AssetLoader

class MockDownloadTask:AssetDownloaderTaskProtocol{
    func resume() {
        
    }
    
    func cancel() {
        
    }
    
    
}

class MockDownloader:AssetDownloaderProtocol{
    
    func download(from url: URL, completion: @escaping AssetDownloadCompletionHandler) -> AssetDownloaderTaskProtocol {
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch let err {
            completion(.failure(NetworkError(err)))
        }
      return MockDownloadTask()
    }
    
    func resumeDownload(with task: AssetDownloadTask, completion: @escaping AssetDownloadCompletionHandler) {
        
    }
    
    
}
