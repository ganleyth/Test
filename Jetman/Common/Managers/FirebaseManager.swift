//
//  FirebaseManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let loginManager = LoginManager()
    let friendManager = FriendManager()
    let challengeManager = ChallengeManager()
}
