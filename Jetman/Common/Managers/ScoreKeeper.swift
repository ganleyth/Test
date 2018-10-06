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
    
    func addPointsForCoin() {
        currentScore += 10
    }
    
    func addPointsForDestroyedObstacle(in level: Level) {
        currentScore += (10 + 2 * level)
    }
    
    func reset(didGameEnd: Bool) {
        if didGameEnd {
            currentScore = 0
        }
    }
}
