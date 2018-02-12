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
    static let triangleOfDefaultSize: UIBezierPath = {
        let size = Constants.TileMapLayer.defaultTileSize
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: size.width/2.0, y: 0))
        path.close()
        
        return path
    }()
    
    static let bottomBoundaryOfDefaultWidth: UIBezierPath = {
        let defaultWidth = Constants.TileMapLayer.defaultTileWidth * CGFloat(Constants.TileMapLayer.defaultColumnCount)
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: defaultWidth, y: 0))
        
        return path
    }()
}
