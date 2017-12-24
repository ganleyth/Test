//
//  Obstacle.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

final class Obstacle: SKTileMapNode {
    let length: Int
    private let top: SKTileGroup
    private let middle: SKTileGroup
    private let bottom: SKTileGroup
    
    init(length: Int, top: SKTileGroup, middle: SKTileGroup, bottom: SKTileGroup) {
        guard length > 0 && length <= Constants.TileMapLayer.maxObstacleHeight else {
            Logger.severe("Invalid obstacle length", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
        
        self.length = length
        self.top = top
        self.middle = middle
        self.bottom = bottom
        
        super.init()
        
        tileSet = SKTileSet(tileGroups: [top, middle, bottom])
        tileSize = CGSize(width: Constants.TileMapLayer.defaultTileWidth, height: Constants.TileMapLayer.defaultTileHeight)
        anchorPoint = CGPoint.zero
        configureForSetLength()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureForSetLength() {
        numberOfRows = length + 2
        numberOfColumns = 1
        
        let bottomIndex = 0
        let topIndex = length + 1
        let middleIndexes = 1...length
        
        setTileGroup(bottom, forColumn: 0, row: bottomIndex)
        setTileGroup(top, forColumn: 0, row: topIndex)
        
        for i in middleIndexes {
            setTileGroup(middle, forColumn: 0, row: i)
        }
    }
}
