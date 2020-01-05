//
//  DataServiceTests.swift
//  MindValleyAppTests
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import XCTest
@testable import ExampleApp

class DataServiceTests: XCTestCase {

    var sut:DataService<[MindValleyPin]>!
    override func setUp() {
        sut = DataService()
    }

    func test_serviceFetchesPins(){
        var expectedPins:[MindValleyPin] = []
        let expectation = self.expectation(description: "dataservice")
        sut.fetchData(url: Constants.dataUrl) { result in
            switch result{
            case .failure(_):
                break
            case .success(let pins):
                expectedPins = pins
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertFalse(expectedPins.isEmpty)
    }

}
