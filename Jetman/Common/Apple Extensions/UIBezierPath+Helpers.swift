//
//  UIBezierPath+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 1/22/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIBezierPath {
    static func triangle(of size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: size.width/2.0, y: 0))
        path.close()
        
        return path
    }
}
