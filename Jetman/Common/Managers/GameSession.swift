//
//  GameSession.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import GameKit

class GameSession: GKGameSession {
    
    static let shared = GameSession()
    
    var currentUser: User?
    let settings = Settings()
    let levelManager = LevelManager()
    let scoreKeeper = ScoreKeeper(pointsPerTileMap: 100)
    var highScore: Int? {
        get {
            return UserDefaults.standard.object(forKey: Constants.UserDefaults.highScore) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.highScore)
        }
    }
    
    let soundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
