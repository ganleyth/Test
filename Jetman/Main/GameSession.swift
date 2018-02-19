//
//  GameSession.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import GameKit

class GameSession: GKGameSession {
    
    static let shared = GameSession()
    
    let settings = Settings()
}