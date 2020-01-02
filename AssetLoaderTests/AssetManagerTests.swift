//
//  AssetManagerTests.swift
//  AssetLoaderTests
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import XCTest

@testable import AssetLoader

class AssetManagerTest:XCTestCase{
    
    var sut:AssetManager!
    override func setUp() {
        sut = AssetManager()
    }
    
    func test_MangerDownloadsAndCachesImages(){
        var expectedImage:UIImage?
        let expectation = self.expectation(description: "test1")
        sut.downloadImage(for: makeUrlFrom(Values.workingUrl)) { (image, err) in
            expectedImage = image
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(expectedImage)
    }
    
    func makeUrlFrom(_ string:String)->URL{
        return URL(string: string)!
    }
}
