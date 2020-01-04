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
    
    func test_MangerDownloadsAndCachesSmallImages(){
        var expectedImage:UIImage?
        let expectation = self.expectation(description: "test2")
        sut.downloadImage(for: makeUrlFrom(Values.workingsmallImageUrl)) { (image, err) in
            expectedImage = image
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(expectedImage)
    }
    
    func test_MangerDownloadsAndCachesSmallImagesWithExplicitTaskIdentifier(){
        var expectedImage:UIImage?
        let expectation = self.expectation(description: "test2")
        sut.downloadImage(for: makeUrlFrom(Values.workingsmallImageUrl), identifier: 1) { (image, err) in
            expectedImage = image
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(expectedImage)
    }
    
    func makeUrlFrom(_ string:String)->URL{
        return URL(string: string)!
    }
    
    
    func test_ManagerDownloadsAndCachesJSONData(){
        var expectedData:[MockPin] = []
        
        let expectation = self.expectation(description: "test2")
        sut.download(from: URL(string: Values.pinUrl)!, for: [MockPin].self) { (data, err) in
            if let data = data{
                expectedData = data
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertFalse(expectedData.isEmpty)
    }
    
    func test_ManagerDownloadsAndFIlterWithCursor(){
        let cursor = Cursor(limit: 10) { (lhs, rhs) -> Bool in
            guard let left = lhs as? MindValleyPin, let right = rhs as? MindValleyPin else {return false}
            return left.id < right.id
        }
        var expectedResults:[MindValleyPin] = []
        
        let downloader = MockDownloader()
        let expectation = self.expectation(description: "test3")
        let sut = AssetManager(with: AssetCache(name: "testCache", config: AssetCache.Configuration()), downloader: downloader)
        
        sut.download(from: Values.jsonLocation, for: [MindValleyPin].self,with: cursor) { (data, err) in
            print(err?.localizedDescription ?? "Unknown")
            if let data = data{
                expectedResults.append(contentsOf: data)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(expectedResults.count, 10)
        
    }
    
    func test_ManagerDownloadsAndFilterWithCursorWhenNextDataIsRequested(){
        var cursor = Cursor(limit: 2) { (lhs, rhs) -> Bool in
            guard let left = lhs as? MockPin, let right = rhs as? MockPin else {return false}
            return left.id < right.id
        }
        var expectedResults:[MockPin] = []
        
        let downloader = MockDownloader()
        let expectation = self.expectation(description: "test3")
        let sut = AssetManager(with: AssetCache(name: "testCache", config: AssetCache.Configuration()), downloader: downloader)
        
        sut.download(from: Values.jsonLocation, for: [MockPin].self,with: cursor) { (data, err) in
            if let data = data{
                expectedResults.append(contentsOf: data)
                cursor.next()
                sut.download(from: Values.jsonLocation, for: [MockPin].self,with: cursor) { (data, err) in
                    if let data = data{
                        expectedResults.append(contentsOf: data)
                    }
                    expectation.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(expectedResults.count, 4)
        
    }
    
    
    
    struct MockPin:Codable{
        
        static func < (lhs: AssetManagerTest.MockPin, rhs: AssetManagerTest.MockPin) -> Bool {
            return rhs.id < lhs.id
        }
        
        let id:String
        let color:String
    }
}
