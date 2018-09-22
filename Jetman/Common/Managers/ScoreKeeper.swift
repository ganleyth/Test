//
//  ScoreKeeper.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/11/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import CoreGraphics

class ScoreKeeper {
    var currentScore = 0
    let pointsPerTileMap: Int
    var lastXPosition: CGFloat = 0
    
    init(pointsPerTileMap: Int) {
        self.pointsPerTileMap = pointsPerTileMap
    }
    
    func update(forPosition position: CGPoint, maxPosition: CGFloat, completedTileMaps: Int) {
        let x = position.x
        currentScore = currentScore + Int((x - lastXPosition) * 1000 / maxPosition)
        lastXPosition = x
    }
    
    func reset(didGameEnd: Bool) {
        lastXPosition = 0
        if didGameEnd {
            currentScore = 0
        }
    }
}
