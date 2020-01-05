//
//  PinDataControllerTest.swift
//  ExampleAppTests
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import XCTest
@testable import ExampleApp

class PinDataControllerTest: XCTestCase {

    var sut:PinDataController<MockServiceObject>!
    var collectionView:UICollectionView!
    override func setUp() {
        let service = MockServiceObject()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        sut = PinDataController(service: service, collectionView: collectionView)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_ControllerDataWorks(){
        sut.fetchData()
        let numberofItems = sut.collectionView(sut.collectionView!, numberOfItemsInSection: 0)
        XCTAssertEqual(numberofItems, 10)
    }
    
    func test_fetchLoadMoreLoadsMore(){
        sut.fetchData()
        sut.fetchMoreData()
        XCTAssertEqual(sut.pins.count, 20)
    }
    
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}




