//
//  DataService.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import AssertLoaderKit

protocol DataServiceProtocol {
    associatedtype DataType
    
    typealias FetchResult = (Result<DataType,NetworkError>) -> Void
    func fetchData(url:URL, completion:@escaping FetchResult)
    func fetchData(url:URL, with cursor:Cursor, completion:@escaping FetchResult)
    var assetManager:AssetManager{get}
}






class DataService<DataType:Codable>{
    
    let assetManager:AssetManager
    let customCache:AssetCache?
    init(specifiedCache:AssetCache? = nil) {
        customCache = specifiedCache
        assetManager = AssetManager(with:specifiedCache)
        
    }

}

extension DataService:DataServiceProtocol{
    
    typealias DataType  = DataType
    
    func fetchData(url: URL, completion: @escaping (Result<DataType, NetworkError>) -> Void) {
        assetManager.download(from: url, for: DataType.self) { (data, err) in
            guard let data = data, err == nil else {
                completion(.failure(NetworkError(err)))
                return
            }
            completion(.success(data))
        }
    }
    
    func fetchData(url: URL, with cursor: Cursor, completion: @escaping (Result<DataType, NetworkError>) -> Void) {
        assetManager.download(from: url, for: DataType.self, with: cursor) {  (data, err) in
           guard let data = data, err == nil else {
               completion(.failure(NetworkError(err)))
               return
           }
           completion(.success(data))
        }
    }
    
}
