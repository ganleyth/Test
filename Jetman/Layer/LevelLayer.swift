//
//  LevelLayer.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

final class LevelLayer: Layer {
    private let leadingTileMap: SKTileMapNode
    private let trailingTileMap: SKTileMapNode
    private let obstacleBuildingBlocks: ObstacleBuildingBlocks
    private let bottomBoundaryBuildingBlocks: BottomBoundaryBuildingBlocks
    
    private var currentBottomBoundaryMaxRow = 0
    
    init(windowSize: CGSize, tileSet: SKTileSet) {
        
        guard
            let obstacleTileTop = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.top.rawValue }).first,
            let obstacleTileMiddle = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.middle.rawValue }).first,
            let obstacleTileBottom = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.bottom.rawValue }).first else {
                Logger.severe("Invalid tile set for level layer - obstacle", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
        }
        
        obstacleBuildingBlocks = ObstacleBuildingBlocks(topTile: obstacleTileTop, middleTile: obstacleTileMiddle, bottomTile: obstacleTileBottom)
        
        guard
            let bottomBoundaryTopMiddleTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.topMiddle.rawValue }).first,
            let bottomBoundaryTopIncreaseTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.topIncrease.rawValue }).first,
            let bottomBoundaryTopDecreaseTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.topDecrease.rawValue }).first,
            let bottomBoundaryMiddleTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.middle.rawValue }).first,
            let bottomBoundaryMiddleIncreaseTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.middleIncrease.rawValue }).first,
            let bottomBoundaryMiddleDecreaseTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.middleDecrease.rawValue }).first else {
                Logger.severe("Invalid tile set for level layer - bottom boundary", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
        }
        
        bottomBoundaryBuildingBlocks = BottomBoundaryBuildingBlocks(topMiddleTile: bottomBoundaryTopMiddleTile, topIncreaseTile: bottomBoundaryTopIncreaseTile, topDecreaseTile: bottomBoundaryTopDecreaseTile, middleTile: bottomBoundaryMiddleTile, middleIncreaseTile: bottomBoundaryMiddleIncreaseTile, middleDecreaseTile: bottomBoundaryMiddleDecreaseTile)
        
        leadingTileMap = SKTileMapNode()
        trailingTileMap = SKTileMapNode()
        
        super.init()
        
        initializeTileMap(leadingTileMap, with: tileSet, windowSize: windowSize)
        initializeTileMap(trailingTileMap, with: tileSet, windowSize: windowSize)
        
        trailingTileMap.position = CGPoint(x: leadingTileMap.frame.maxX, y: 0.0)
        
        addChild(leadingTileMap)
        addChild(trailingTileMap)
    }
    
    private func initializeTileMap(_ tileMap: SKTileMapNode, with tileSet: SKTileSet, windowSize: CGSize) {
        tileMap.tileSet = tileSet
        tileMap.anchorPoint = CGPoint.zero
        tileMap.position = CGPoint.zero
        tileMap.zPosition = Constants.ZPosition.foregroundLayer.floatValue
        configureTileMap(tileMap, forWindowSize: windowSize)
        populateBottomBoundary(for: tileMap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Tile map population
extension LevelLayer {
    
    private func configureTileMap(_ tileMap: SKTileMapNode, forWindowSize windowSize: CGSize) {
        tileMap.tileSize = CGSize(width: Constants.TileMapLayer.defaultTileWidth, height: Constants.TileMapLayer.defaultTileHeight)
        let numberOfRows = Constants.TileMapLayer.defaultRowCount
        tileMap.numberOfRows = numberOfRows
        let numberOfColumnsToFillWindow = Int(windowSize.width / (windowSize.height / CGFloat(numberOfRows)))
        
        // Multiply by 1.5 to provide enough columns to always fill screen
        tileMap.numberOfColumns = Int(Double(numberOfColumnsToFillWindow) * 1.5)
        
        tileMap.scaleToWindowSize(windowSize)
    }

    private func populateBottomBoundary(for tileMap: SKTileMapNode) {
        var currentRow = currentBottomBoundaryMaxRow

        for j in 0..<tileMap.numberOfColumns {
            tileMap.setTileGroup(bottomBoundaryBuildingBlocks.topMiddleTile, forColumn: j, row: currentRow)
        }

        currentRow -= 1

        while currentRow >= 0 {
            for j in 0..<tileMap.numberOfColumns {
                tileMap.setTileGroup(bottomBoundaryBuildingBlocks.middleTile, forColumn: j, row: currentRow)
            }
            currentRow -= 1
        }
    }
}

struct ObstacleBuildingBlocks {
    let topTile: SKTileGroup
    let middleTile: SKTileGroup
    let bottomTile: SKTileGroup
}

struct BottomBoundaryBuildingBlocks {
    let topMiddleTile: SKTileGroup
    let topIncreaseTile: SKTileGroup
    let topDecreaseTile: SKTileGroup
    let middleTile: SKTileGroup
    let middleIncreaseTile: SKTileGroup
    let middleDecreaseTile: SKTileGroup
}

