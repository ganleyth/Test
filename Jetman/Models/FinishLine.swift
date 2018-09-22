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
        let physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0,
                                                             y: 0,
                                                             width: CGFloat(numberOfColumns) * Constants.TileMapLayer.defaultTileWidth,
                                                             height: CGFloat(numberOfRows) * Constants.TileMapLayer.defaultTileHeight))
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.finishLine
        physicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        self.physicsBody = physicsBody
    }
}
