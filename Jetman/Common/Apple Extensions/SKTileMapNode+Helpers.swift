//
//  SKTileMapNode+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

extension SKTileMapNode {
    
    var scaledTileSize: CGSize {
        let scale = self.scale ?? 1
        return CGSize(width: tileSize.width * scale, height: tileSize.height * scale)
    }

    func positionForTileAt(row: Int, column: Int) -> CGPoint? {
        guard
            row <= numberOfRows,
            column <= numberOfColumns else {
                Logger.error("Requested row or column is out of range", filePath: #file, funcName: #function, lineNumber: #line)
                return nil
        }
        
        let x = CGFloat(column) * tileSize.width
        let y = CGFloat(row) * tileSize.height
        
        return CGPoint(x: x, y: y)
    }
    
    func scaledPositionForTileAt(row: Int, column: Int) -> CGPoint? {
        guard let scale = scale else {
            Logger.debug("xScale and yScale are not equal", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        guard let unscaledPosition = positionForTileAt(row: row, column: column) else {
            Logger.debug("Could not compute unscaled position", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        return unscaledPosition * scale
    }
    
    func addRectangularPhysicsBody(with coordinatePosition: CoordinatePosition, numberOfRows: Int, numberOfColumns: Int, type: TileType) {
        let width = CGFloat(numberOfColumns) * tileSize.width
        let height = CGFloat(numberOfRows) * tileSize.height
        
        let sprite = SKSpriteNode(color: .clear, size: CGSize(width: width, height: height))
        sprite.anchorPoint = CGPoint.zero
        let x = CGFloat(coordinatePosition.x) * tileSize.width
        let y = CGFloat(coordinatePosition.y) * tileSize.height
        sprite.position = CGPoint(x: x, y: y)
        
        let physicsBody: SKPhysicsBody
        
        switch type {
        case .bottomBoundary:
            physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
            physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.bottomBoundary
            physicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
            sprite.name = Constants.SpriteName.bottomBoundary
        case .obstacle:
            physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
            physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
            physicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
            sprite.name = Constants.SpriteName.obstacle
        case .platform:
            physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
            physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.platform
            physicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.none
            sprite.name = Constants.SpriteName.platform
        }
        
        physicsBody.restitution = 0.05
        sprite.physicsBody = physicsBody
        
        addChild(sprite)
    }
    
    func addObstaclePhysicsBodies(with lengthCoordinatePosition: CoordinatePosition, length: Int) {
        let lengthSpriteSize = CGSize(width: tileSize.width, height: CGFloat(length) * tileSize.height)
        let lengthSprite = SKSpriteNode(color: .clear, size: CGSize(width: tileSize.width, height: CGFloat(length) * tileSize.height))
        lengthSprite.anchorPoint = CGPoint.zero
        let x = CGFloat(lengthCoordinatePosition.x) * tileSize.width
        let lengthY = CGFloat(lengthCoordinatePosition.y) * tileSize.height
        lengthSprite.position = CGPoint(x: x, y: lengthY)
        let lengthPhysicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: lengthSpriteSize))
        lengthPhysicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
        lengthPhysicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        lengthPhysicsBody.restitution = 0.05
        lengthSprite.physicsBody = lengthPhysicsBody
        lengthSprite.name = Constants.SpriteName.obstacle
        addChild(lengthSprite)

        let topSprite = SKSpriteNode(color: .clear, size: tileSize)
        topSprite.anchorPoint = CGPoint.zero
        topSprite.position = CGPoint(x: x, y: lengthY + CGFloat(length) * tileSize.height)
        topSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint.zero, size: tileSize))
        topSprite.physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
        topSprite.physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        topSprite.physicsBody?.restitution = 0.05
        topSprite.name = Constants.SpriteName.obstacle
        addChild(topSprite)

        let bottomSprite = SKSpriteNode(color: .clear, size: tileSize)
        bottomSprite.anchorPoint = CGPoint.zero
        bottomSprite.position = CGPoint(x: x, y: lengthY - tileSize.height)
        bottomSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: UIBezierPath.triangleOfDefaultSize.cgPath)
        bottomSprite.physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.obstacle
        bottomSprite.physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.player
        bottomSprite.physicsBody?.restitution = 0.05
        bottomSprite.name = Constants.SpriteName.obstacle
        addChild(bottomSprite)
    }
}

extension SKTileMapNode {
    enum TileType {
        case bottomBoundary
        case obstacle
        case platform
    }
}
