//
//  Settings.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import GameKit

class Settings {
    var allowHaptics = false
    var allowSounds = false
    var playerGender = Player.Gender.boy {
        didSet {
            switch playerGender {
            case .boy: if !SpriteLoader.shared.hasLoadedForBoy { SpriteLoader.shared.loadSprites(for: .boy) }
            case .girl: if !SpriteLoader.shared.hasLoadedForGirl { SpriteLoader.shared.loadSprites(for: .girl) }
            }
        }
    }
}
