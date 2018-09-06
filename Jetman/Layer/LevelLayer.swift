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
    private var guideTileMap: SKTileMapNode
    private let obstacleBuildingBlocks: ObstacleBuildingBlocks
    private let bottomBoundaryBuildingBlocks: BottomBoundaryBuildingBlocks
    private let platformBuildingBlocks: PlatformBuildingBlocks
    
    private var currentBottomBoundaryMaxRow = 0
    
    private var obstaclePositions: [CoordinatePosition] = []
    private var platformPositions: [CoordinatePosition] = []
    
    private var platformRemoved = false
    
    lazy var absoluteTileMapWidth: CGFloat = {
        return guideTileMap.frame.width
    }()
    
    var currentPosition: CGPoint {
        return -guideTileMap.position
    }
    
    var startingPositionForPlayer: CGPoint {
        let sumOfX = platformPositions.reduce(0.0) { (sum, nextPosition) -> CGFloat in
            return sum + CGFloat(nextPosition.x) * guideTileMap.scaledTileSize.width
        }
        
        let x = sumOfX / CGFloat(platformPositions.count)
        let y = CGFloat(guideTileMap.numberOfRows - 2) * guideTileMap.scaledTileSize.height
        let xOffsetForCentering = 0.5 * guideTileMap.scaledTileSize.width
        return CGPoint(x: x + xOffsetForCentering, y: y)
    }
    
    private lazy var possiblePositionsForLargeObstacle: [Int] = {
        var possiblePositions: [Int] = []
        let minPossiblePosition = currentBottomBoundaryMaxRow + 1
        let maxPossiblePosition = Constants.TileMapLayer.defaultRowCount - (Constants.TileMapLayer.maxObstacleHeight + 2)
        for i in minPossiblePosition...maxPossiblePosition {
            if (i - minPossiblePosition != 2) && (maxPossiblePosition - i != 2) {
                possiblePositions.append(i)
            }
        }
        
        return possiblePositions
    }()
    
    private lazy var numberOfColumns: Int = {
        return ((LevelManager.shared.currentObstacleCount + 1) * 5)
    }()

    init(windowSize: CGSize, tileSet: SKTileSet) {
        
        guard
            let obstacleTileTop = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.top.rawValue }).first,
            let obstacleTileMiddle = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.middle.rawValue }).first,
            let obstacleTileBottom = tileSet.tileGroups.filter({ $0.name == Constants.ObstacleTileName.bottom.rawValue }).first else {
                Logger.severe("Invalid tile set for level layer - obstacle", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
        }
        
        obstacleBuildingBlocks = ObstacleBuildingBlocks(topTile: obstacleTileTop, middleTile: obstacleTileMiddle, bottomTile: obstacleTileBottom)
        
        guard let bottomBoundaryTopMiddleTile = tileSet.tileGroups.filter({ $0.name == Constants.BottomBoundaryTileName.topMiddle.rawValue }).first else {
                Logger.severe("Invalid tile set for level layer - bottom boundary", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
        }
        
        bottomBoundaryBuildingBlocks = BottomBoundaryBuildingBlocks(topMiddleTile: bottomBoundaryTopMiddleTile)
        
        guard
            let platformLeadingTile = tileSet.tileGroups.filter({ $0.name == Constants.PlatformTileName.leading }).first,
            let platformMiddleTile = tileSet.tileGroups.filter({ $0.name == Constants.PlatformTileName.middle }).first,
            let platformTrailingTile = tileSet.tileGroups.filter({ $0.name == Constants.PlatformTileName.trailing }).first else {
                Logger.severe("Invalid tile set for level layer - platform", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
        }
        
        platformBuildingBlocks = PlatformBuildingBlocks(leadingTile: platformLeadingTile, middleTile: platformMiddleTile, trailingTile: platformTrailingTile)
        
        guideTileMap = SKTileMapNode()
        
        super.init()
        
        initializeTileMap(guideTileMap, with: tileSet, windowSize: windowSize)
        populateGuideTileMap()
        addPlatformToFirstTileMap()
        
        addChild(guideTileMap)
    }
    
    private func initializeTileMap(_ tileMap: SKTileMapNode, with tileSet: SKTileSet, windowSize: CGSize) {
        tileMap.tileSet = tileSet
        tileMap.anchorPoint = CGPoint.zero
        tileMap.position = CGPoint.zero
        tileMap.zPosition = Constants.ZPosition.foregroundLayer.floatValue
        configureTileMap(tileMap, forWindowSize: windowSize)
        populateBottomBoundary(for: tileMap)
        addPhysicsBodyToUpperBoundary(of: tileMap)
    }
    
    private func configureTileMap(_ tileMap: SKTileMapNode, forWindowSize windowSize: CGSize) {
        tileMap.tileSize = CGSize(width: Constants.TileMapLayer.defaultTileWidth, height: Constants.TileMapLayer.defaultTileHeight)
        tileMap.numberOfRows = Constants.TileMapLayer.defaultRowCount
        tileMap.numberOfColumns = numberOfColumns
        
        tileMap.scaleToWindowSize(windowSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(with delta: TimeInterval, in frameSize: CGSize) {
        super.update(with: delta, in: frameSize)
    }
}

// MARK: - Tile map population
extension LevelLayer {

    private func populateBottomBoundary(for tileMap: SKTileMapNode) {
        for j in 0..<tileMap.numberOfColumns {
            tileMap.setTileGroup(bottomBoundaryBuildingBlocks.topMiddleTile, forColumn: j, row: currentBottomBoundaryMaxRow)
        }

        addBottomBoundaryPhysicsBody(to: tileMap, atLevel: currentBottomBoundaryMaxRow)
    }
    
    private func addPlatformToFirstTileMap() {
        let middleRow = Int(guideTileMap.numberOfRows / 2) - 1
        guideTileMap.setTileGroup(platformBuildingBlocks.leadingTile, forColumn: 0, row: middleRow)
        guideTileMap.setTileGroup(platformBuildingBlocks.trailingTile, forColumn: 1, row: middleRow)
        
        for i in 0...1 {
            platformPositions.append(CoordinatePosition(x: i, y: middleRow))
        }
        
        guideTileMap.addRectangularPhysicsBody(with: CoordinatePosition(x: 0, y: middleRow), numberOfRows: 1, numberOfColumns: 2, type: .platform)
    }
    
    private func populateGuideTileMap() {
        
//        let randomNumberOfObstaclesZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: (maxNumberOfObstacles - minNumberOfObstacles) + 1)
//        let randomNumberOfObstacles = minNumberOfObstacles + randomNumberOfObstaclesZeroIndexed
//
//        var lengths = [Int]()
//        for _ in 0..<randomNumberOfObstacles {
//            lengths.append(randomObstacleLength())
//        }
//
//        let positions = generateRandomObstaclePositions(for: trailingTileMap, numberOfSegments: randomNumberOfObstacles, lengths: lengths)
//
//        for i in 0..<positions.count {
//            let position = positions[i]
//            let length = lengths[i]
//            addObstacleTo(trailingTileMap, length: length, xIndex: position.x, yIndex: position.y)
//        }
    }
    
    private func randomObstacleLength() -> Int {
        let randomLengthZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: Constants.TileMapLayer.maxObstacleHeight)
        let randomLength = randomLengthZeroIndexed + 1
        return randomLength
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
        obstaclePositions.append(CoordinatePosition(x: xIndex, y: bottomIndex))
        tileMap.setTileGroup(obstacleBuildingBlocks.topTile, forColumn: xIndex, row: topIndex)
        obstaclePositions.append(CoordinatePosition(x: xIndex, y: topIndex))
        
        for i in middleIndexes {
            tileMap.setTileGroup(obstacleBuildingBlocks.middleTile, forColumn: xIndex, row: i)
            obstaclePositions.append(CoordinatePosition(x: xIndex, y: i))
        }
        
        guard let middleIndexesMin = middleIndexes.min() else { return }
        
        guideTileMap.addObstaclePhysicsBodies(with: CoordinatePosition(x: xIndex, y: middleIndexesMin), length: length)
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
        
        let minY = currentBottomBoundaryMaxRow + 1
        
        var positions = [CoordinatePosition]()
        
        for i in 0..<lengths.count {
            let length = lengths[i]
            let lengthPlusEndCaps = length + 2
            let minX = segmentXPositions[i]
            let maxX = segmentXPositions[i + 1] - 2
            let maxY = tileMap.numberOfRows - lengthPlusEndCaps
            
            guard maxX - minX >= 0,
                maxY - minY >= 0 else {
                    Logger.error("Too small of position increments", filePath: #file, funcName: #function, lineNumber: #line)
                    continue
            }
            
            let randomXZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: (maxX - minX) + 1)
            
            let randomY: Int
            switch length {
            case 1:
                let randomYZeroIndexed = GKRandomSource.sharedRandom().nextInt(upperBound: (maxY - minY) + 1)
                randomY = minY + randomYZeroIndexed
            case 2:
                guard let y = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possiblePositionsForLargeObstacle).first as? Int else {
                    fatalError("No possible positions for obstacle")
                }
                randomY = y
            default:
                fatalError("Unexpected obstacle length")
            }
            
            let randomX = minX + randomXZeroIndexed
            
            positions.append(CoordinatePosition(x: randomX, y: randomY))
        }
        
        return positions
    }
    
    private func addPhysicsBodyToUpperBoundary(of tileMap: SKTileMapNode) {
        let physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: tileMap.frame.minX, y: tileMap.frame.maxY), to: CGPoint(x: tileMap.frame.maxX, y: tileMap.frame.maxY))
        physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.topBoundary
        tileMap.physicsBody = physicsBody
    }
}

// MARK: - Update
extension LevelLayer {
    private func removePlatform() {
        for position in platformPositions {
            guideTileMap.setTileGroup(nil, forColumn: position.x, row: position.y)
        }
        
        for childToRemove in guideTileMap.children.filter({ $0.name == Constants.SpriteName.platform }) {
            guideTileMap.removeChildren(in: [childToRemove])
        }
    }
}

// MARK: - Bottom boundary physics
extension LevelLayer {

    private func addBottomBoundaryPhysicsBody(to tileMap: SKTileMapNode, atLevel boundaryLevel: Int) {
        let boundaryYPosition = CGFloat(boundaryLevel) * tileMap.tileSize.height + Constants.TileMapLayer.waterLevelYPosition
        let node = SKShapeNode(path: UIBezierPath.bottomBoundaryOfDefaultWidth.cgPath)
        node.strokeColor = .clear
        node.position = CGPoint(x: 0, y: boundaryYPosition)
        node.name = Constants.SpriteName.bottomBoundary
        let physicsBodyWidth = tileMap.tileSize.width * CGFloat(tileMap.numberOfColumns)
        let physicsBody = SKPhysicsBody(edgeFrom: CGPoint.zero, to: CGPoint(x: physicsBodyWidth, y: 0))
        physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.bottomBoundary
        node.physicsBody = physicsBody
        tileMap.addChild(node)
    }
    
    private func removeBottomBoundaryPhysicsBody(of tileMap: SKTileMapNode) {
        guard let nodeToRemove = tileMap.childNode(withName: Constants.SpriteName.bottomBoundary) else { return }
        nodeToRemove.removeFromParent()
    }
}

// MARK: - Support types
struct ObstacleBuildingBlocks {
    let topTile: SKTileGroup
    let middleTile: SKTileGroup
    let bottomTile: SKTileGroup
}

struct BottomBoundaryBuildingBlocks {
    let topMiddleTile: SKTileGroup
}

struct PlatformBuildingBlocks {
    let leadingTile: SKTileGroup
    let middleTile: SKTileGroup
    let trailingTile: SKTileGroup
}

struct CoordinatePosition {
    let x: Int
    let y: Int
}
