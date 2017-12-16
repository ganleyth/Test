//
//  CGPoint+HelpersTests.swift
//  JetmanTests
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import XCTest
@testable import Jetman

class CGPoint_HelpersTests: XCTestCase {

    func testWhenAddingPointsThatResultIsVectorAddition() {
        let a = CGPoint(x: 5.3, y: 4.2)
        let b = CGPoint(x: 2.1, y: 2.1)
        
        let result = a + b
        
        XCTAssertEqual(result.x, 7.4, accuracy: 0.001)
        XCTAssertEqual(result.y, 6.3, accuracy: 0.001)
    }
    
    func testWhenMultiplyingScalarToPointThatResultIsScalarMultiplication() {
        let p = CGPoint(x: 3.2, y: 4.3)
        let s: CGFloat = 2.0
        
        let result = p * s
        
        XCTAssertEqual(result.x, 6.4, accuracy: 0.001)
        XCTAssertEqual(result.y, 8.6, accuracy: 0.001)
    }
    
    func testWhenUsingUnaryAdditionOnPointThatSecondOperandIsAdded() {
        var a = CGPoint(x: 5.3, y: 4.2)
        let b = CGPoint(x: 2.1, y: 2.1)
        
        a += b
        
        XCTAssertEqual(a.x, 7.4, accuracy: 0.001)
        XCTAssertEqual(a.y, 6.3, accuracy: 0.001)
    }
    
}
