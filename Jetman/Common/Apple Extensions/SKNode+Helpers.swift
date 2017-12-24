//
//  SKNode+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/10/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func scaleToWindowSize(_ windowSize: CGSize, height: Bool = true, multiplier: CGFloat = 1.0) {
        var scale = height ? windowSize.height / frame.size.height : windowSize.width / frame.size.width
        scale *= multiplier
        setScale(scale)
    }
    
    var scale: CGFloat? {
        return abs(xScale - yScale) <= 0.001 ? xScale : nil
    }
    
}
