//
//  CGFloat+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 1/20/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
