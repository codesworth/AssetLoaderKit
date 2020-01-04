//
//  AssetManagerTest.swift
//  AssetLoaderTests
//
//  Created by Shadrach Mensah on 01/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import XCTest
@testable import AssetLoader

class AssetDownloaderTest: XCTestCase {

    func test_downloadFromWorkingUrlWorks(){
        let sut = AssetDownloader(session: .shared)
        let url = URL(string:Values.workingUrl)!
        var expected:Data? = nil
        let expectation = self.expectation(description: "imageDownload")
        sut.download(from: url) { result in
            switch result{
            case .failure( _):
                break
            case .success(let data):
                expected = data
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(expected)
    }
    
    func test_downloadFromWorkingUrlRegularWorks(){
        let sut = AssetDownloader(session: .shared)
        let url = URL(string:Values.workingUrl2)!
        var expected:Data? = nil
        let expectation = self.expectation(description: "imageDownload")
        sut.download(from: url) { result in
            switch result{
            case .failure( _):
                break
            case .success(let data):
                expected = data
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(expected)
    }
    
    func test_downloadFromWorkingUrlRegularWorksAndConvertsToImage(){
        let sut = AssetDownloader(session: .shared)
        let url = URL(string:Values.workingUrl2)!
        var expected:UIImage? = nil
        let expectation = self.expectation(description: "imageDownload")
        sut.download(from: url) { result in
            switch result{
            case .failure( _):
                break
            case .success(let data):
                expected = UIImage(data: data)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(expected)
    }
    
    func test_downloadFromWrongUrlDoesntWork(){
        let sut = AssetDownloader(session: .shared)
        let url = URL(string:Values.badUrl)!
        var expected:Data? = nil
        let expectation = self.expectation(description: "imageDownload")
        sut.download(from: url) { result in
            switch result{
            case .failure( _):
                break
            case .success(let data):
                expected = data
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNil(expected)
    }
    


}
