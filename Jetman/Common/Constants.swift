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
    
    struct LoggerDefaults {
        static let defaultFormat = "yyyy-MM-dd hh:mm:ss.SSS"
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
    
    enum ObstacleTileName: String {
        case top = "obstacleTileTop"
        case middle = "obstacleTileMiddle"
        case bottom = "obstacleTileBottom"
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
