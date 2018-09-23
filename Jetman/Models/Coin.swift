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
    
    init(position: CGPoint) {
        let radius = 40
        let width = radius * 2
        let height = width * 262 / 240
        super.init(texture: Coin.texture, color: .clear, size: CGSize(width: width, height: height))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = position
        let pb = SKPhysicsBody(circleOfRadius: CGFloat(radius), center: position)
        pb.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.coin
        pb.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
