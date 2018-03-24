//
//  ChallengeManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
import GameKit

class ChallengeManager: Manager {
    
    let inbox = Inbox()
    let outbox = Outbox()
    
    enum Leaderboard: String {
        case global = "GlobalLeaderboard"
    }
    
    func report(scoreValue: Int, to leaderboard: Leaderboard, completion: (() -> Void)?) {
        let score = GKScore(leaderboardIdentifier: leaderboard.rawValue)
        score.value = Int64(scoreValue)
        GKScore.report([score]) { (error) in
            if let error = error {
                Logger.error("Could not report score: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            completion?()
        }
    }
    
}
