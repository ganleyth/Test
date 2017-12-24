//
//  LevelLayer.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

final class LevelLayer: Layer {
    private let tileMap = SKTileMapNode()
    private let obstacleTileTop: SKTileGroup
    private let obstacleTileMiddle: SKTileGroup
    private let obstacleTileBottom: SKTileGroup
    
    init(windowSize: CGSize, tileSet: SKTileSet) {
        
        guard
            let obstacleTileTop = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.top.rawValue }).first,
            let obstacleTileMiddle = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.middle.rawValue }).first,
            let obstacleTileBottom = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.bottom.rawValue }).first else {
                Logger.severe("Invalid tile set for level layer", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
        }
        
        self.obstacleTileTop = obstacleTileTop
        self.obstacleTileMiddle = obstacleTileMiddle
        self.obstacleTileBottom = obstacleTileBottom
        
        super.init()
        
        tileMap.tileSet = tileSet
        tileMap.anchorPoint = CGPoint.zero
        tileMap.position = CGPoint.zero
        tileMap.zPosition = Constants.ZPosition.foregroundLayer.floatValue
        configureTileMap(for: windowSize)
        populateTileMap()
        
        addChild(tileMap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Tile map population
extension LevelLayer {
    
    private func configureTileMap(for windowSize: CGSize) {
        tileMap.tileSize = CGSize(width: Constants.TileMapLayer.defaultTileWidth, height: Constants.TileMapLayer.defaultTileHeight)
        let numberOfRows = Constants.TileMapLayer.defaultRowCount
        tileMap.numberOfRows = numberOfRows
        let numberOfColumnsToFillWindow = Int(windowSize.width / (windowSize.height / CGFloat(numberOfRows)))
        
        // Multiply by 1.5 to provide enough columns to always fill screen
        tileMap.numberOfColumns = Int(Double(numberOfColumnsToFillWindow) * 1.5)
        
        tileMap.scaleToWindowSize(windowSize)
    }
    
    private func populateTileMap() {
        let testI = 7
        let testJ = 7
        
        let obstacle = Obstacle(length: 1, top: obstacleTileTop, middle: obstacleTileMiddle, bottom: obstacleTileBottom)
        
        if let position = tileMap.scaledPositionForTileAt(row: testI, column: testJ) {
            obstacle.position = position
            obstacle.zPosition = Constants.ZPosition.playerAndObstacles.floatValue
            tileMap.addChild(obstacle)
        }
    }
    
}

