//
//  SKSpriteNode+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/16/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    static func name(for positionInMap: CoordinatePosition) -> String {
        return "\(positionInMap.x),\(positionInMap.y)"
    }
    
    func setAnchorPointToZero() {
        anchorPoint = CGPoint.zero
    }
    
    func setName(for positionInMap: CoordinatePosition) {
        name =  "\(positionInMap.x),\(positionInMap.y)"
    }
    
}
