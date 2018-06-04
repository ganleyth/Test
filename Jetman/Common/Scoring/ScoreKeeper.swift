//
//  ScoreKeeper.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/11/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import CoreGraphics

protocol ScoreKeeperDelegate: class {
    func scoreDidReachCheckpointMultiple()
}

class ScoreKeeper {
    var currentScore = 0
    let pointsPerTileMap: Int
    let scoreCheckpointCount: Int
    
    weak var delegate: ScoreKeeperDelegate?
    
    init(pointsPerTileMap: Int, scoreCheckpointCount: Int) {
        self.pointsPerTileMap = pointsPerTileMap
        self.scoreCheckpointCount = scoreCheckpointCount
    }
    
    func update(forPosition position: CGPoint, maxPosition: CGFloat, completedTileMaps: Int) {
        currentScore = Int((CGFloat(completedTileMaps) + position.x / maxPosition) * CGFloat(pointsPerTileMap))
        guard currentScore > 0 else { return }
        if currentScore % scoreCheckpointCount == 0 {
            delegate?.scoreDidReachCheckpointMultiple()
        }
    }
}
