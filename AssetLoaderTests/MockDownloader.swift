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


typealias MindValleyPins = [MindValleyPin]
struct MindValleyPin:Codable {
    
    
    
    let id:String
    let created_at:String
    let width:Int
    let height:Int
    let color:String
    let likes:Int
    let liked_by_user:Bool
    let user:User
    let urls:PinURLS
    
    let categories: [PinCategory]
    
    var dateCreated:Date{
        return Date()
    }
    
    
}


extension MindValleyPin{
    struct PinURLS:Codable {
        
        let raw:String
        let full:String
        let regular:String
        let small:String
        let thumb:String
        
        var rawURL:URL?{
           return URL(string: raw)
        }
        
        var smallUrl:URL?{
            return URL(string: small)
        }
        
        var regularUrl:URL?{
            return URL(string: regular)
        }
        
        
    }


    struct PinCategory:Codable {
        let id:Int
        let title:String
        let photo_count:Int
        
    }
}



extension MindValleyPin:Comparable{
    
    static func < (lhs: MindValleyPin, rhs: MindValleyPin) -> Bool {
        return lhs.dateCreated < rhs.dateCreated
    }
    
    static func == (lhs: MindValleyPin, rhs: MindValleyPin) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    
}


struct User:Codable {
    let id:String
    let username:String
    let name:String
    let profile_image:ProfileImage
    
    var profileImageUrl:URL?{
        return URL(string: profile_image.medium)
    }
    
    var profileThumbNailUrl:URL?{
        return URL(string: profile_image.small)
    }
    
    var profileImageLargeUrl:URL?{
        return URL(string: profile_image.large)
    }
    
    struct ProfileImage:Codable {
        let small:String
        let medium:String
        let large:String
    }
    
}
