//
//  LevelLayer.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit
import GameKit

final class LevelLayer: Layer {
    fileprivate let leadingTileMap: SKTileMapNode
    fileprivate let trailingTileMap: SKTileMapNode
    fileprivate let obstacleBuildingBlocks: ObstacleBuildingBlocks
    fileprivate let bottomBoundaryBuildingBlocks: BottomBoundaryBuildingBlocks
    
    private var currentBottomBoundaryMaxRow = 0
    
    var difficulty = 1
    
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
        populateTrailingTileMap()
        
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

// MARK: - Tile map population
extension LevelLayer {
    fileprivate func populateTrailingTileMap() {
        let minNumberOfObstacles = difficulty * 4
        let maxNumberOfObstacles = difficulty * 5
        
        let randomNumberOfObstaclesZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: (maxNumberOfObstacles - minNumberOfObstacles) + 1)
        let randomNumberOfObstacles = minNumberOfObstacles + randomNumberOfObstaclesZeroIndexed
        
        var lengths = [Int]()
        for _ in 0..<randomNumberOfObstacles {
            lengths.append(randomObstacleLength())
        }
        
        let positions = generateRandomObstaclePositions(for: trailingTileMap, numberOfSegments: randomNumberOfObstacles, lengths: lengths)
    
        for i in 0..<positions.count {
            let position = positions[i]
            let length = lengths[i]
            addObstacleTo(trailingTileMap, length: length, xIndex: position.x, yIndex: position.y)
        }
    }
    
    private func addObstacleTo(_ tileMap: SKTileMapNode, length: Int, xIndex: Int, yIndex: Int) {
        guard length > 0 && length <= Constants.TileMapLayer.maxObstacleHeight else {
            Logger.severe("Invalid obstacle length", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
        
        let bottomIndex = yIndex
        let topIndex = yIndex + length + 1
        let middleIndexes = (bottomIndex + 1)...(bottomIndex + length)
        
        tileMap.setTileGroup(obstacleBuildingBlocks.bottomTile, forColumn: xIndex, row: bottomIndex)
        tileMap.setTileGroup(obstacleBuildingBlocks.topTile, forColumn: xIndex, row: topIndex)
        
        for i in middleIndexes {
            tileMap.setTileGroup(obstacleBuildingBlocks.middleTile, forColumn: xIndex, row: i)
        }
    }
    
    private func generateRandomObstaclePositions(for tileMap: SKTileMapNode, numberOfSegments: Int, lengths: [Int]) -> [CoordinatePosition] {
        guard numberOfSegments == lengths.count else {
            Logger.severe("Mismatch of numberOfSegments and lengths.count", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
        
        let segmentWidth = Int(Double(tileMap.numberOfColumns) / Double(numberOfSegments))
        var segmentXPositions = [Int]()
        
        for i in 0...numberOfSegments {
            let segmentXPosition = i * segmentWidth
            segmentXPositions.append(segmentXPosition)
        }
        
        let minY = currentBottomBoundaryMaxRow + 2
        
        var positions = [CoordinatePosition]()
        
        for i in 0..<lengths.count {
            let length = lengths[i]
            let minX = segmentXPositions[i]
            let maxX = segmentXPositions[i + 1]
            let maxY = tileMap.numberOfRows - length - 2
            
            let randomXZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: (maxX - minX) + 1)
            let randomYZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: (maxY - minY) + 1)
            
            let randomX = minX + randomXZeroIndexed
            let randomY = minY + randomYZeroIndexed
            
            positions.append(CoordinatePosition(x: randomX, y: randomY))
        }
        
        return positions
    }
    
    private func randomObstacleLength() -> Int {
        let randomLengthZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        let randomLength = randomLengthZeroIndexed + 1
        return randomLength
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

struct CoordinatePosition {
    let x: Int
    let y: Int
}
