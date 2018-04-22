//
//  ChallengeManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation

class ChallengeManager: Manager {
    
    func reportFirstTurnScore(for challenge: Challenge, with completion: @escaping (Error?) -> Void) {
        guard let currentUser = currentUser else { completion(GeneralError.userNotLoggedIn); return }
        
        let group = DispatchGroup()
        var completionError: Error? = nil
        
        let currentUserReference = defaultDatabaseReference.child("\(currentUser.uid)challenges/received/\(challenge.id)/score")
        group.enter()
        currentUserReference.setValue(challenge.score) { (error, _) in
            completionError = error
            group.leave()
        }
        
        let opponentReference = defaultDatabaseReference.child("\(challenge.opponentID)/challenges/sent/\(challenge.id)/score")
        group.enter()
        opponentReference.setValue(challenge.score) { (error, _) in
            completionError = error
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(completionError)
        }
    }
}
