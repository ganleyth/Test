//
//  LayerTests.swift
//  JetmanTests
//
//  Created by Thomas Ganley on 12/10/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Jetman

class LayerTests: XCTestCase {
    
    var layer: Layer!
    var spriteA: SKSpriteNode!
    var spriteB: SKSpriteNode!
    
    override func setUp() {
        super.setUp()
        
        layer = Layer()
        spriteA = SKSpriteNode(color: .white, size: CGSize(width: 75.0, height: 50.0))
        spriteB = SKSpriteNode(color: .black, size: CGSize(width: 100.0, height: 50.0))
        
        spriteA.position = CGPoint(x: 50.0, y: 50.0)
        spriteB.position = CGPoint(x: 20.0, y: 50.0)
        layer.addChild(spriteA)
        layer.addChild(spriteB)
    }
    
    override func tearDown() {
        layer = nil
        spriteA = nil
        spriteB = nil
        
        super.tearDown()
    }
    
    func testWhenUpdatedWithDeltaChildNodePositionsAreUpdated() {
        layer.velocity = CGPoint(x: -1.0, y: -1.0)
        
        layer.update(with: 2.0)
        
        XCTAssertEqual(spriteA.position.x, 48.0, accuracy: 0.001)
        XCTAssertEqual(spriteA.position.y, 48.0, accuracy: 0.001)
        XCTAssertEqual(spriteB.position.x, 18.0, accuracy: 0.001)
        XCTAssertEqual(spriteB.position.y, 48.0, accuracy: 0.001)
    }

}
