//
//  DownloaderTask.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation


open class AssetDownloadTask:NSObject{
    

    let task:URLSessionDownloadTask
    
    
    var resumeData:Data
    
    init(task:URLSessionDownloadTask) {
        self.task = task
        resumeData = Data()
    }
    
    
    public func resume(){
        task.resume()
    }
    
    public func cancel(){
        task.cancel()
    }
}


extension AssetDownloadTask: URLSessionDataDelegate{
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        resumeData.append(data)
    }
}
