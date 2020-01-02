//
//  AssetCacheTest.swift
//  AssetLoaderTests
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import XCTest

@testable import AssetLoader


class AssetCacheTest:XCTestCase{
    
    var sut:AssetCache!
    
    override class func setUp() {
        sut = AssetCache(name: Values.cacheName, config: AssetCache.Configuration(maxCapacity: Values.cacheCapacity))
    }
    
    func test_cacheInsertOneObjectAndRetrieveOneObject(){
        
        sut.set(object: Values.randomCacheData, for: Values.testCacheID)
        
        let returnedObject = sut.getObject(for: Values.testCacheID)
        
        XCTAssertEqual(Values.randomCacheData, returnedObject?.value)
    }
    
    func test_CacheRemovesExpiredObjects(){
        let assetObject = AssetCache.AssetCacheObject(value: Values.randomCacheData, expiration: .distantPast)
        sut.set(object: assetObject, for:Values.testCacheID)
        let returnedObject = sut.getObject(for: Values.testCacheID)
        XCTAssertNil(returnedObject)
    }
    
    
}
