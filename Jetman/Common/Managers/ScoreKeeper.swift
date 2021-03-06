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
    var coinsLeftToFireMode = 2
    
    func addPointsForCoin(andDecreaseCoinsLeftToFireMode decreaseCoinsLeftToFireMode: Bool) {
        currentScore += 10
        if decreaseCoinsLeftToFireMode {
            coinsLeftToFireMode -= 1
            if coinsLeftToFireMode == 0 {
                NotificationCenter.default.post(name: Constants.Notifications.coinsLeftToFireModeZero, object: self)
            }
        }
        postScoreChange()
    }
    
    @discardableResult
    func addPointsForDestroyedObstacle(in level: Level) -> Int {
        let increment = (10 + 2 * level)
        currentScore += increment
        postScoreChange()
        return increment
    }
    
    func reset(didGameEnd: Bool) {
        if didGameEnd {
            currentScore = 0
        }
        resetCoinsToFireMode()
        postScoreChange()
    }
    
    func resetCoinsToFireMode() {
        coinsLeftToFireMode = 10
        postScoreChange()
    }
    
    private func postScoreChange() {
        NotificationCenter.default.post(name: Constants.Notifications.scoreDidUpdate, object: self)
    }
}
