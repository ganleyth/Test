//
//  SKTileMapNode+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

extension SKTileMapNode {
    
    func positionForTileAt(row: Int, column: Int) -> CGPoint? {
        guard
            row <= numberOfRows,
            column <= numberOfColumns else {
                Logger.error("Requested row or column is out of range", filePath: #file, funcName: #function, lineNumber: #line)
                return nil
        }
        
        let x = CGFloat(column) * tileSize.width
        let y = CGFloat(row) * tileSize.height
        
        return CGPoint(x: x, y: y)
    }
    
    func scaledPositionForTileAt(row: Int, column: Int) -> CGPoint? {
        guard let scale = scale else {
            Logger.debug("xScale and yScale are not equal", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        guard let unscaledPosition = positionForTileAt(row: row, column: column) else {
            Logger.debug("Could not compute unscaled position", filePath: #file, funcName: #function, lineNumber: #line)
            return nil
        }
        return unscaledPosition * scale
    }
    
}
