//
//  SKNode+HelpersTests.swift
//  JetmanTests
//
//  Created by Thomas Ganley on 12/10/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Jetman

class SKNode_HelpersTests: XCTestCase {
    
//    static let spriteSizesExpectation = XCTestExpectation(description: "spriteSizesSet")
//
//    func testWhenScaledByHeightTheSizeIsUpdated() {
//        let view = SKView(frame: CGRect(x: 0, y: 0, width: 500, height: 300))
//        let scene = MockSKScene()
//        view.presentScene(scene)
//        let spriteA = SKSpriteNode(color: .black, size: CGSize(width: 100.0, height: 50.0))
//        let spriteB = SKSpriteNode(color: .blue, size: CGSize(width: 20.0, height: 40.0))
//        scene.spriteA = spriteA
//        scene.spriteB = spriteB
//        spriteA.addChild(spriteB)
//        scene.addChild(spriteA)
//        let windowSize = CGSize(width: 400.0, height: 250.0)
//        
//        spriteA.scaleToWindowSize(windowSize)
//        scene.update(1.0)
//        
//        wait(for: [SKNode_HelpersTests.spriteSizesExpectation], timeout: 3.0)
//        
//        XCTAssertEqual(spriteA.frame.size.height, 250.0, accuracy: 0.001)
//        XCTAssertEqual(spriteA.frame.size.width, 500.0, accuracy: 0.001)
//        XCTAssertEqual(spriteB.frame.size.height, 200.0, accuracy: 0.001)
//        XCTAssertEqual(spriteB.frame.size.width, 100.0, accuracy: 0.001)
//    }
//}
//
//extension SKNode_HelpersTests {
//    
//    class MockSKScene: SKScene {
//        
//        var spriteA: SKSpriteNode?
//        var spriteB: SKSpriteNode?
//        
//        var spriteASizeAfterUpdate: CGSize?
//        var spriteBSizeAfterUpdate: CGSize?
//        
//        override func didFinishUpdate() {
//            super.didFinishUpdate()
//            
//            spriteASizeAfterUpdate = spriteA?.frame.size
//            spriteBSizeAfterUpdate = spriteB?.frame.size
//            spriteSizesExpectation.fulfill()
//        }
//    }
}
