//
//  TestValues.swift
//  AssetLoaderTests
//
//  Created by Shadrach Mensah on 01/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation


enum Values {
    static let pinUrl = "http://pastebin.com/raw/wgkJgazE"
    static let workingUrl = "https://images.unsplash.com/photo-1464550883968-cec281c19761"
    static let badUrl = "https://image.unsplash.com/photo-1464550883968-cec281c19761"
    static let cacheName = "test_cache"
    static let cacheCapacity = 10
    static let randomCacheData = Data(repeating: 0, count: 100)
    static let testCacheID = "test_id"
}
