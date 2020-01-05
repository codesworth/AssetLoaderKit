//
//  MockServiceObject.swift
//  ExampleAppTests
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation
@testable import ExampleApp
import AssetLoader





class MockServiceObject:DataServiceProtocol{
    func fetchData(url: URL, with cursor: Cursor, completion: @escaping (Result<MindValleyPins, NetworkError>) -> Void) {
        completion(.success(dummyData))
    }
    
    var assetManager: AssetManager{
        return AssetManager()
    }
    
    
    var dummyData:MindValleyPins = []
    
    init() {
        for i in 0..<10{
            let pin = MindValleyPin(id: "\(i)", created_at: "", width: 0, height: 0, color: "", likes: 0, liked_by_user: false, user: User(id: "\(i)", username: "", name: "", profile_image: User.ProfileImage(small: "", medium: "", large: "")), urls: MindValleyPin.PinURLS(raw: "", full: "", regular: "", small: "", thumb: ""), categories: [])
            dummyData.append(pin)
            
        }
    }
    
    typealias DataType = MindValleyPins
    
    func fetchData(url: URL, completion: @escaping (Result<MindValleyPins, NetworkError>) -> Void) {
        completion(.success(dummyData))
    }
    
}
