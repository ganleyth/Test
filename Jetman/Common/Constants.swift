//
//  Constants.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/3/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import CoreGraphics

struct Constants {
    
    enum BottomBoundaryTileName: String {
        case topMiddle = "bottomBoundaryTopMiddle"
        case topIncrease = "bottomBoundaryTopIncrease"
        case topDecrease = "bottomBoundaryTopDecrease"
        case middle = "bottomBoundaryMiddle"
        case middleIncrease = "bottomBoundaryMiddleIncrease"
        case middleDecrease = "bottomBoundaryMiddleDecrease"
    }
    
    struct Challenges {
        static let challengeID = "challengeID"
        static let id = "id"
        static let opponentID = "opponentID"
        static let score = "score"
        static let selfInitiated = "self_initiated"
        static let senderID = "senderID"
    }
    
    struct CloudKit {
        struct User {
            static let recordName = "User"
            static let iCloudRecordReference = "iCloudRecordReference"
        }
    }
    
    struct Friend {
        static let id = "id"
        static let recordAgainst = "record_against"
    }
    
    struct Leaderboard {
        static let global: LeaderboardName = "GlobalLeaderboard"
    }
    
    struct LoggerDefaults {
        static let defaultFormat = "yyyy-MM-dd hh:mm:ss.SSS"
    }
    
    struct Notifications {
        static let gameCenterVCReceived = Notification.Name(rawValue: "GameCenterVCReceived")
        static let challengeReceived = Notification.Name(rawValue: "ChallengeReceived")
    }
    
    enum ObstacleTileName: String {
        case top = "obstacleTileTop"
        case middle = "obstacleTileMiddle"
        case bottom = "obstacleTileBottom"
    }
    
    struct PlatformTileName {
        static let leading = "platformLeading"
        static let middle = "platformMiddle"
        static let trailing = "platformTrailing"
    }
    
    struct Player {
        static let animationKey = "animation"
        static let ascendKey = "ascend"
        static let smokeEmitterName = "smokeEmitter"
    }
    
    struct PhysicsBodyCategoryBitMask {
        static let bottomBoundary: UInt32 = 0b00000000000000000000000000000001
        static let player: UInt32         = 0b00000000000000000000000000000010
        static let platform: UInt32       = 0b00000000000000000000000000000100
        static let obstacle: UInt32       = 0b00000000000000000000000000001000
        static let topBoundary: UInt32    = 0b00000000000000000000000000010000
    }
    
    struct PhysicsBodyContactTestBitMask {
        static let boundariesAndObstacles: UInt32 = 0b00000000000000000000000000011101
        static let none: UInt32                   = 0b00000000000000000000000000000000
        static let player: UInt32                 = 0b00000000000000000000000000000010
    }
    
    struct PhysicsBodyCollisionBitMask {
        static let platform: UInt32 = 0b00000000000000000000000000000100
    }
    
    struct RepeatingLayer {
        static let repeatedNodeOffset: CGFloat = -0.01
    }
    
    struct SpriteName {
        static let bottomBoundary = "bottomBoundary"
        static let obstacle = "obstacle"
        static let platform = "platform"
        static let player = "player"
    }
    
    struct TileMapLayer {
        static let defaultTileWidth: CGFloat = 128.0
        static let defaultTileHeight: CGFloat = 128.0
        static let defaultRowCount = 16
        static let startingVelocity = -220
        static let velocityDifficultyIncrement = CGPoint(x: -2, y: 0)
        
        static var defaultTileSize: CGSize {
            return CGSize(width: defaultTileWidth, height: defaultTileHeight)
        }
        
        static var maxObstacleHeight: Int {
            return Int(defaultRowCount / 2)
        }
        
        static var defaultColumnCount: Int {
            let windowSize = UIWindow().frame.size
            let numberOfColumnsToFillWindow = Int(windowSize.width / (windowSize.height / CGFloat(defaultRowCount)))
            
            // Multiply by 1.5 to provide enough columns to always fill screen
            return Int(Double(numberOfColumnsToFillWindow) * 1.5)
        }
        
        static let waterLevelDict: [BottomBoundaryTileName: (leading: CGPoint, trailing: CGPoint)] = [
            .topMiddle: (CGPoint(x: 0, y: 85), CGPoint(x: 128, y: 85)),
            .topIncrease: (CGPoint(x: 35, y: 0), CGPoint(x: 128, y: 85)),
            .topDecrease: (CGPoint(x: 0, y: 85), CGPoint(x: 98, y: 0)),
            .middleIncrease: (CGPoint(x: 0, y: 85), CGPoint(x: 30, y: 128)),
            .middleDecrease: (CGPoint(x: 98, y: 128), CGPoint(x: 128, y: 85))
        ]
        
        static let waterLevelYPosition: CGFloat = 85.0
    }
    
    struct UserDefaults {
        static let allowHaptics = "allowHaptics"
        static let allowSounds = "allowSounds"
        static let highScore = "highScore"
        static let uid = "uid"
    }
    
    enum ZPosition: Int {
        case backgroundLayer = 0
        case playerAndObstacles
        case foregroundLayer
        case emitter
        
        var floatValue: CGFloat {
            return CGFloat(self.rawValue)
        }
    }
    
}

typealias LeaderboardName = String

enum GeneralError: Error {
    case userNotLoggedIn
    case noOpponentID
}
