//
//  DynamicObstacle.swift
//  Jetman
//
//  Created by Thomas Ganley on 10/21/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import SpriteKit
import GameKit

class DynamicObstacle: Obstacle {
    var verticalVelocity: CGFloat
    let minY: CGFloat
    let maxY: CGFloat
    
    init(length: Int, coordinatePosition: CoordinatePosition, obstacleBuildingBlocks: ObstacleBuildingBlocks, verticalVelocity: CGFloat, levelMinY: CGFloat, levelMaxY: CGFloat) {
        self.verticalVelocity = verticalVelocity
        self.minY = levelMinY
        self.maxY = levelMaxY - (Constants.TileMapLayer.defaultTileHeight * CGFloat(length + 2))
        super.init(length: length, coordinatePosition: coordinatePosition, obstacleBuildingBlocks: obstacleBuildingBlocks)
        
        let direction = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
        configureMovement(startingWithMovingUp: (direction == 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMovement(startingWithMovingUp: Bool) {
        let positionY = CGFloat(coordinatePosition.y) * tileSize.height
        let fullRangeMoveTime = TimeInterval((maxY - minY) / verticalVelocity)
        let firstMove: SKAction
        let up = SKAction.moveTo(y: maxY, duration: fullRangeMoveTime)
        let down = SKAction.moveTo(y: minY, duration: fullRangeMoveTime)
        let sequence: SKAction
        if startingWithMovingUp {
            firstMove = SKAction.moveTo(y: maxY, duration: Double((maxY - positionY) / verticalVelocity))
            sequence = SKAction.sequence([down, up])
        } else {
            firstMove = SKAction.moveTo(y: minY, duration: Double((positionY - minY) / verticalVelocity))
            sequence = SKAction.sequence([up, down])
        }
        
        let loop = SKAction.repeatForever(sequence)
        let firstMovePlusLoop = SKAction.sequence([firstMove, loop])
        
        run(firstMovePlusLoop)
    }
}
