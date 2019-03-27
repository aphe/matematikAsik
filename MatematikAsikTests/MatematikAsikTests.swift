//
//  MatematikAsikTests.swift
//  MatematikAsikTests
//
//  Created by Afriyandi Setiawan on 27/03/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import XCTest

@testable import MatematikAsik

var calculate: CalculateViewController!

class MatematikAsikTests: XCTestCase {

    override func setUp() {
        calculate = CalculateViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFibonanci() {
        var fib:[Int64] = []
        self.measure {
            fib = calculate.dFib(4)
        }
        XCTAssertEqual(fib, [0, 1, 1, 2])
    }
    
    func testPrime()  {
        var prime:[Int64] = []
        self.measure {
            prime = calculate.generatePrimes(to: 4)
        }
        XCTAssertEqual(prime, [2, 3, 5, 7])
    }
    
    func testAdding() {
        let add = calculate.addOrMultiply(1, 2, operation: .add)
        XCTAssertEqual(add, 3)
    }
    
    func testMultiply() {
        let mul = calculate.addOrMultiply(1, 2, operation: .multiply)
        XCTAssertEqual(mul, 2)
    }

}
