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
    static let workingUrl2 = "https://images.unsplash.com/photo-1464545022782-925ec69295ef?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=35537ab900b5bd8fc247e61f08345c49"
    static let workingsmallImageUrl = "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=d5682032c546a3520465f2965cde1cec"
    static let badUrl = "https://image.unsplash.com/photo-1464550883968-cec281c19761"
    static let cacheName = "test_cache"
    static let cacheCapacity = 10
    static let randomCacheData = Data(repeating: 0, count: 100)
    static let testCacheID = "test_id"
    static let jsonLocation = Bundle.init(for: AssetManagerTest.self).url(forResource: "mindvalley", withExtension: "json")!
     
}
