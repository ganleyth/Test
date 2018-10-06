//
//  LevelManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 9/6/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation

typealias Level = Int

class LevelManager {
    
    var currentLevel: Int {
        get {
            return UserDefaults.standard.value(forKey: Constants.UserDefaults.currentLevel) as? Int ?? 1
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.currentLevel)
        }
    }
    
    lazy var obstacleItemizedCount: (staticShort: Int, dynamicShort: Int, staticLong: Int) = {
        var counter = 0
        var byThreesCounter = 0
        var staticShortCounter = 0
        var dynamicShortCounter = 0
        var staticLongCounter = 0
        
        while counter < currentLevel {
            switch byThreesCounter {
            case 0:
                staticShortCounter += 1
            case 1:
                dynamicShortCounter += 1
            case 2:
                staticLongCounter += 1
            default:
                fatalError("Unexpected byThreesCounter")
            }
            
            if byThreesCounter == 2 {
                byThreesCounter = 0
            } else {
                byThreesCounter += 1
            }
            
            counter += 1
        }
        
        return (5 + staticShortCounter, dynamicShortCounter, staticLongCounter)
    }()
    
    lazy var obstacleCount: Int = {
        return obstacleItemizedCount.staticShort + obstacleItemizedCount.dynamicShort + obstacleItemizedCount.staticLong
    }()
}
