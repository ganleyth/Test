//
//  LevelManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 9/6/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation

class LevelManager {
    
    static let shared = LevelManager()
    
    var currentLevel: Int {
        get {
            return UserDefaults.standard.value(forKey: Constants.UserDefaults.currentLevel) as? Int ?? 1
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.currentLevel)
        }
    }
    
    var currentObstacleCount: Int {
        return 30 + currentLevel
    }
}
