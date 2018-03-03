//
//  MemberService.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
import GameKit

class MemberService {
    
    static let shared = MemberService()
    
    var localPlayer: GKLocalPlayer {
        return GKLocalPlayer.localPlayer()
    }
    
    var localPlayerIsAuthenticated: Bool {
        return localPlayer.isAuthenticated
    }
    
}
