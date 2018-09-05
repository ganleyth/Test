//
//  Obstacle.swift
//  Jetman
//
//  Created by Thomas Ganley on 9/5/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKTileMapNode {
    let length: Int
    let isDynamic: Bool
    
    init(length: Int, isDynamic: Bool = false) {
        self.length = length
        self.isDynamic = isDynamic
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
