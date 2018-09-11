//
//  FinishLine.swift
//  Jetman
//
//  Created by Thomas Ganley on 9/9/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import SpriteKit

class FinishLine: SKTileMapNode {
    private enum FinishLineTile {
        case black
        case white
        
        func inverted() -> FinishLineTile {
            return self == .black ? .white : .black
        }
    }
    
    let length: Int
    let width: Int
    
    private let blackTileGroup = SKTileGroup(tileDefinition: SKTileDefinition(texture: SKTexture(imageNamed: "BlackTile"), size: Constants.TileMapLayer.defaultTileSize))
    private let whiteTileGroup = SKTileGroup(tileDefinition: SKTileDefinition(texture: SKTexture(imageNamed: "WhiteTile"), size: Constants.TileMapLayer.defaultTileSize))
    
    init(length: Int, width: Int) {
        self.length = length
        self.width = width
        
        super.init()
        
        self.tileSet = SKTileSet(tileGroups: [blackTileGroup, whiteTileGroup])
        self.anchorPoint = CGPoint.zero
        self.zPosition = Constants.ZPosition.playerAndObstacles.floatValue
        self.tileSize = CGSize(width: Constants.TileMapLayer.defaultTileWidth, height: Constants.TileMapLayer.defaultTileHeight)
        self.numberOfRows = length
        self.numberOfColumns = width
        
        populateFinishLine()
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateFinishLine() {
        var firstTile = FinishLineTile.black
        var currentTile = FinishLineTile.black
        
        for j in 0..<width {
            for i in 0..<length {
                let tileGroup = currentTile == .black ? blackTileGroup : whiteTileGroup
                setTileGroup(tileGroup, forColumn: j, row: i)
                currentTile = currentTile.inverted()
            }
            
            firstTile = firstTile.inverted()
            currentTile = firstTile
        }
    }
    
    private func setupPhysicsBody() {
//        let lengthSpriteSize = CGSize(width: tileSize.width, height: CGFloat(length) * tileSize.height)
//        let lengthSprite = SKSpriteNode(color: .clear, size: CGSize(width: tileSize.width, height: CGFloat(length) * tileSize.height))
//        lengthSprite.anchorPoint = CGPoint.zero
//        let x: CGFloat = 0
//        let lengthY = tileSize.height
//        lengthSprite.position = CGPoint(x: x, y: lengthY)
//        let lengthPhysicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: lengthSpriteSize))
//        lengthPhysicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
//        lengthPhysicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
//        lengthPhysicsBody.restitution = 0.05
//        lengthSprite.physicsBody = lengthPhysicsBody
//        lengthSprite.name = Constants.SpriteName.obstacle
//        addChild(lengthSprite)
//        
//        let topSprite = SKSpriteNode(color: .clear, size: tileSize)
//        topSprite.anchorPoint = CGPoint.zero
//        topSprite.position = CGPoint(x: x, y: lengthY + CGFloat(length) * tileSize.height)
//        topSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: tileSize))
//        topSprite.physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
//        topSprite.physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
//        topSprite.physicsBody?.restitution = 0.05
//        topSprite.name = Constants.SpriteName.obstacle
//        addChild(topSprite)
//        
//        let bottomSprite = SKSpriteNode(color: .clear, size: tileSize)
//        bottomSprite.anchorPoint = CGPoint.zero
//        bottomSprite.position = CGPoint(x: x, y: lengthY - tileSize.height)
//        bottomSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: UIBezierPath.triangleOfDefaultSize.cgPath)
//        bottomSprite.physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
//        bottomSprite.physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
//        bottomSprite.physicsBody?.restitution = 0.05
//        bottomSprite.name = Constants.SpriteName.obstacle
//        addChild(bottomSprite)
    }
}
