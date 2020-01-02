//
//  DownloaderTask.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation


open class AssetDownloadTask{
    
    let task:URLSessionDownloadTask
    
    let identifier:Int = 0
    
    init(task:URLSessionDownloadTask) {
        self.task = task
    }
    
    public func resume(){
        task.resume()
    }
    
    public func cancel(){
        task.cancel()
    }
}
