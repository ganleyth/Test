//
//  Constants.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/3/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
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
        static let defaultWidthIdle: CGFloat = 30
        static let defaultWidthFlying: CGFloat = 30
        static let defaultWidthDead: CGFloat = 30
        static let animationKey = "animation"
        static let ascendKey = "ascend"
    }
    
    struct PhysicsBodyCategoryBitMask {
        static let bottomBoundary: UInt32 = 0b00000000000000000000000000000001
        static let player: UInt32         = 0b00000000000000000000000000000010
        static let platform: UInt32       = 0b00000000000000000000000000000100
        static let obstacle: UInt32       = 0b00000000000000000000000000001000
        static let topBoundary: UInt32    = 0b00000000000000000000000000010000
    }
    
    struct PhysicsBodyContactTestBitMask {
        static let boundariesAndObstacles: UInt32 = 0b00000000000000000000000000011001
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
    }
    
    enum ZPosition: Int {
        case backgroundLayer = 0
        case foregroundLayer
        case playerAndObstacles
        
        var floatValue: CGFloat {
            return CGFloat(self.rawValue)
        }
    }
    
}
