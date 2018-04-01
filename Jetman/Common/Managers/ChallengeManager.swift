//
//  ChallengeManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
import GameKit

class ChallengeManager {

    func report(scoreValue: Int, to leaderboard: LeaderboardName, completion: (() -> Void)?) {
        let score = GKScore(leaderboardIdentifier: leaderboard)
        score.shouldSetDefaultLeaderboard = true
        score.value = Int64(scoreValue)
        GKScore.report([score]) { (error) in
            if let error = error {
                Logger.error("Could not report score: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            completion?()
        }
    }
}
