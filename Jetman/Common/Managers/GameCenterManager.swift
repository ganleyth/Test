//
//  GameCenterManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import GameKit

class GameCenterManager {

    static let shared = GameCenterManager()
    
    lazy var challengeManager = ChallengeManager()
    lazy var friendManager = FriendManager()
    
    var friends: [GKPlayer]? {
        return friendManager.friends
    }
    
    // MARK: - User authentication
    func authenticateLocalPlayer(completion: @escaping (_ gameCenterVC: UIViewController?, _ error: Error?) -> Void) {
//        MemberService.shared.localPlayer.authenticateHandler = { (gameCenterVC, error) in
//            DispatchQueue.main.async {
//                completion(gameCenterVC, error)
//            }
//        }
    }
    
    // MARK: - Friend fetching
    func fetchFriends(completion: @escaping () -> Void) {
        friendManager.fetchFriends {
            completion()
        }
    }
}


