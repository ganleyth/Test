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
        for i in 0..<(length - 1) {
            setTileGroup(obstacleBuildingBlocks.middleTile, forColumn: 0, row: i)
        }
        setTileGroup(obstacleBuildingBlocks.topTile, forColumn: 0, row: length - 1)
    }
    
    private func setupPhysicsBody() {
        
    }
    
    private func setupDynamism() {
        
    }
}
