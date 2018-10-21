//
//  Coin.swift
//  Jetman
//
//  Created by Thomas Ganley on 9/22/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    static let texture = SKTexture(imageNamed: "Coin")
    var hasBeenCollected = false
    
    init(position: CGPoint) {
        let radius = 60
        let width = radius * 2
        let height = width * 262 / 240
        super.init(texture: Coin.texture, color: .clear, size: CGSize(width: width, height: height))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = Constants.ZPosition.playerAndObstacles.floatValue
        self.position = position
        let pb = SKPhysicsBody(circleOfRadius: CGFloat(radius), center: CGPoint.zero)
        pb.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.coin
        pb.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        pb.collisionBitMask = 0
        pb.affectedByGravity = false
        physicsBody = pb
        lightingBitMask = Constants.Lighting.fireModeLightBitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRotation() {
        let scale1 = SKAction.scaleX(to: 0.3, duration: 0.1)
        let scale2 = SKAction.scaleX(to: 1.1, duration: 0.15)
        let scale3 = SKAction.scaleX(to: -0.3, duration: 0.1)
        let scale4 = SKAction.scaleX(to: -1.1, duration: 0.15)
        let sequence = SKAction.sequence([scale1, scale3, scale4, scale3, scale1, scale2])
        let loop = SKAction.repeatForever(sequence)
        run(loop)
    }
}
