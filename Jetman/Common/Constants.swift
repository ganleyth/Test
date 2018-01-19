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
        static let defaultSize = CGSize(width: 59, height: 123)
        static let animationKey = "animation"
    }
    
    struct RepeatingLayer {
        static let repeatedNodeOffset: CGFloat = -0.01
    }
    
    struct TileMapLayer {
        static let defaultTileWidth: CGFloat = 128.0
        static let defaultTileHeight: CGFloat = 128.0
        static let defaultRowCount = 16
        
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
