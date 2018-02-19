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
    
    struct LoggerDefaults {
        static let defaultFormat = "yyyy-MM-dd hh:mm:ss.SSS"
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
