//
//  PinViewControllerTests.swift
//  ExampleAppTests
//
//  Created by Shadrach Mensah on 05/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import XCTest
@testable import ExampleApp

class PinViewControllerTests: XCTestCase {
    
    var sut:PinViewController!

    override func setUp() {
        sut = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "\(PinViewController.self)") as? PinViewController
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_loadViewAndPopulatesView(){
        sut.loadViewIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            XCTAssertEqual(self.sut.collectionView.numberOfItems(inSection: 0), 10)
        }
    }

}
