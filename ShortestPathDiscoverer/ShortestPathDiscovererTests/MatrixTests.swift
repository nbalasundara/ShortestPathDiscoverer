//
//  ShortestPathDiscovererTests.swift
//  ShortestPathDiscovererTests
//
//  Created by natarajan b on 2/24/24.
//

import XCTest
@testable import ShortestPathDiscoverer

final class ShortestPathDiscovererTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenerateAndFindPath() throws {
        Task {
            let m = Matrix<Int>(rows: 4, columns: 4)
            for i in 0..<m.rows {
                for j in 0..<m.columns {
                    m[i, j] = Int.random(in: 1..<24)
                }
            }
            var isFound : Bool;
            var length : Int
            var path : [Int]
            (isFound, length, path) = await m.shortestPath(bound: 50) ?? (false, 0, [0])
        }
    }

    func testFirstExampleCase() throws {
        let testCase1 = "3 4 1 2 8 6\n6 1 8 2 7 4\n5 9 3 9 9 5\n8 4 1 3 2 6\n3 7 2 8 6 4"
        Task {
            let validPaths : Set = [[0,1,2,3,3,4], [1,2,3,4,4,5]]
            let m = try Loader.load(testCase1)
            var isFound : Bool;
            var length : Int
            var path : [Int]
            (isFound, length, path) = await m?.shortestPath(bound: 50) ?? (false, 0, [0])
            assert(isFound)
            assert(length==16)
            assert(validPaths.contains(path))
        }
    }

    func testSecondExampleCase() throws {
        let testCase1 = "3 4 1 2 8 6\n6 1 8 2 7 4\n5 9 3 9 9 5\n8 4 1 3 2 6\n3 7 2 1 2 3"
        Task {
            let validPaths : Set = [[1,2,1,5,4,5], [0,1,0,4,3,4]]
            let m = try Loader.load(testCase1)
            var isFound : Bool;
            var length : Int
            var path : [Int]
            (isFound, length, path) = await m?.shortestPath(bound: 50) ?? (false, 0, [0])
            assert(isFound)
            assert(length==11)
            assert(validPaths.contains(path))
        }
    }
    
    func testThirdExampleCase() throws {
        let testCase1 = "19 10 19 10 19\n21 23 20 19 12\n20 12 20 11 10"
        Task {
            let m = try Loader.load(testCase1)
            var isFound : Bool;
            var length : Int
            var path : [Int]
            (isFound, length, path) = await m?.shortestPath(bound: 50) ?? (false, 0, [0])
            assert(!isFound)
            assert(path.count == 3)
            assert(length==48)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case, for the maximum size matrix.
        // Also contains both positive and negative numbers so that the bound can remain 50
        // for the full path. Verifies validity of negative inputs and complete path solution
        // in cases where one exists.
        //
        // On my simulator: 0.279s
        self.measure {
            Task {
                let m = Matrix<Int>(rows: 10, columns: 100)
                var v = 0;
                var sign = 0;
                for i in 0..<m.rows {
                    for j in 0..<m.columns {
                        v = Int.random(in: 1..<10)
                        sign = Int.random(in:0...1)
                        if (sign == 0) {
                            m[i, j] = v
                        } else {
                            m[i, j] = -v
                        }
                    }
                }
                var a : Bool;
                var path : [Int]
                var length : Int
                (a, length, path) = await m.shortestPath(bound: 50) ?? (false, 0, [0])
            }
        }
    }
}
