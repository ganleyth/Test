//
//  Layer.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class Layer: SKNode {
    
    fileprivate(set) var velocity = CGPoint.zero
    
    func update(with delta: TimeInterval, in frameSize: CGSize) {
        for child in children {
            child.position += CGFloat(delta) * velocity
        }
    }
    
    func setVelocity(value: CGPoint) {
        velocity = value
    }
}
