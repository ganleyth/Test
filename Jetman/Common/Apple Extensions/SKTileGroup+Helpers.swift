//
//  SKTileGroup+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 1/21/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import SpriteKit

extension SKTileGroup {
    var primaryTexture: SKTexture? {        
        return rules.first?.tileDefinitions.first?.textures.first
    }
}
