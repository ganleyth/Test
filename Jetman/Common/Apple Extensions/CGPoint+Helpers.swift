//
//  CGPoint+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
import CoreGraphics

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func +=(lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
}

public func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

public func *(scalar: CGFloat, point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

public prefix func -(point: CGPoint) -> CGPoint {
    return CGPoint(x: -point.x, y: -point.y)
}

extension CGPoint {
    func scaledBy(_ scale: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * scale, y: self.y * scale)
    }
}
