//
//  FriendManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import GameKit

class FriendManager {
    
    var friends: [GKPlayer]?
    
    func fetchFriends(completion: @escaping () -> Void) {
        
        MemberService.shared.localPlayer.loadRecentPlayers { [weak self] (players, error) in
            defer { completion() }
            guard let this = self else { return }
            if let error = error {
                Logger.error("Could not fetch friends: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
                return
            }
            
            this.friends = players
        }
    }
    
}
