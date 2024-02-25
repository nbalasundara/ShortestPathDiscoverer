//
//  LoaderTest.swift
//  ShortestPathDiscovererTests
//
//  Created by natarajan b on 2/24/24.
//

import XCTest

final class LoaderTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstLoad() throws {
        try Loader.load("1,2,3\n3 , 4, 5\n")
    }

    func testSecondLoad() throws {
        try Loader.load("\n\n1,2,3\n3 , 4, 5\n\n")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
