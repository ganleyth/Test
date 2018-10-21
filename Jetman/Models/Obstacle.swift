//
//  Obstacle.swift
//  Jetman
//
//  Created by Thomas Ganley on 9/5/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKTileMapNode {
    let length: Int
    let coordinatePosition: CoordinatePosition
    let obstacleBuildingBlocks: ObstacleBuildingBlocks
    let isDynamic: Bool
    
    var hasExploded = false
    
    var heightIncludingCaps: Int {
        return length + 2
    }
    
    init(length: Int, coordinatePosition: CoordinatePosition, obstacleBuildingBlocks: ObstacleBuildingBlocks, isDynamic: Bool = false) {
        self.length = length
        self.coordinatePosition = coordinatePosition
        self.obstacleBuildingBlocks = obstacleBuildingBlocks
        self.isDynamic = isDynamic
        
        super.init()
        
        self.tileSet = SKTileSet(tileGroups: [obstacleBuildingBlocks.bottomTile, obstacleBuildingBlocks.middleTile, obstacleBuildingBlocks.topTile])
        self.anchorPoint = CGPoint.zero
        self.zPosition = Constants.ZPosition.foregroundLayer.floatValue
        self.tileSize = CGSize(width: Constants.TileMapLayer.defaultTileWidth, height: Constants.TileMapLayer.defaultTileHeight)
        self.numberOfRows = length + 2
        self.numberOfColumns = 1
        lightingBitMask = Constants.Lighting.fireModeLightBitMask
        
        assignTileGroups()
        setupPhysicsBody()
        if isDynamic {
            setupDynamism()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func assignTileGroups() {
        setTileGroup(obstacleBuildingBlocks.bottomTile, forColumn: 0, row: 0)
        for i in 1..<(heightIncludingCaps - 1) {
            setTileGroup(obstacleBuildingBlocks.middleTile, forColumn: 0, row: i)
        }
        setTileGroup(obstacleBuildingBlocks.topTile, forColumn: 0, row: heightIncludingCaps - 1)
    }
    
    private func setupPhysicsBody() {
        let lengthSpriteSize = CGSize(width: tileSize.width, height: CGFloat(length) * tileSize.height)
        let lengthSprite = ShapeNodeForPhysicsBody(color: .clear, size: CGSize(width: tileSize.width, height: CGFloat(length) * tileSize.height))
        lengthSprite.attachedToNode = self
        lengthSprite.anchorPoint = CGPoint.zero
        let x: CGFloat = 0
        let lengthY = tileSize.height
        lengthSprite.position = CGPoint(x: x, y: lengthY)
        let lengthPhysicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: lengthSpriteSize))
        lengthPhysicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
        lengthPhysicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        lengthPhysicsBody.restitution = 0.05
        lengthSprite.physicsBody = lengthPhysicsBody
        lengthSprite.name = Constants.SpriteName.obstacle
        addChild(lengthSprite)
        
        let topSprite = ShapeNodeForPhysicsBody(color: .clear, size: tileSize)
        topSprite.attachedToNode = self
        topSprite.anchorPoint = CGPoint.zero
        topSprite.position = CGPoint(x: x, y: lengthY + CGFloat(length) * tileSize.height)
        topSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: tileSize))
        topSprite.physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
        topSprite.physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        topSprite.physicsBody?.restitution = 0.05
        topSprite.name = Constants.SpriteName.obstacle
        addChild(topSprite)
        
        let bottomSprite = ShapeNodeForPhysicsBody(color: .clear, size: tileSize)
        bottomSprite.attachedToNode = self
        bottomSprite.anchorPoint = CGPoint.zero
        bottomSprite.position = CGPoint(x: x, y: lengthY - tileSize.height)
        bottomSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: UIBezierPath.triangleOfDefaultSize.cgPath)
        bottomSprite.physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
        bottomSprite.physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        bottomSprite.physicsBody?.restitution = 0.05
        bottomSprite.name = Constants.SpriteName.obstacle
        addChild(bottomSprite)
    }
    
    private func setupDynamism() {
        
    }
}
