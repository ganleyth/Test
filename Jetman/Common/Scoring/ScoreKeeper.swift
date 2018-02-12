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
    
    init(pointsPerTileMap: Int) {
        self.pointsPerTileMap = pointsPerTileMap
    }
    
    func update(forPosition position: CGPoint, maxPosition: CGFloat, completedTileMaps: Int) {
        currentScore = Int((CGFloat(completedTileMaps) + position.x / maxPosition) * CGFloat(pointsPerTileMap))
        print(currentScore)
    }
}
