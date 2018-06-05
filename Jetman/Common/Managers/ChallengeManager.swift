//
//  ChallengeManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation

class ChallengeManager: Manager {
    
    func initiateContactChallenge(_ challenge: Challenge, with completion: @escaping (Error?) -> Void) {
//        guard let currentUser = currentUser else { completion(GeneralError.userNotLoggedIn); return }
//        
//        let currentUserReference = defaultDatabaseReference.child("\(currentUser.uid)/challenges/sent/\(challenge.id)")
//        currentUserReference.setValue(challenge.dictionaryRepresentation) { (error, _) in
//            DispatchQueue.main.async {
//                completion(error)
//            }
//        }
    }
    
    func reportFirstTurnScore(for challenge: Challenge, with completion: @escaping (Error?) -> Void) {
//        guard let currentUser = currentUser else { completion(GeneralError.userNotLoggedIn); return }
//        guard let opponentID = challenge.opponentID else { completion(GeneralError.noOpponentID); return }
//        
//        let group = DispatchGroup()
//        var completionError: Error? = nil
//        
//        let currentUserReference = defaultDatabaseReference.child("\(currentUser.uid)/challenges/received/\(challenge.id)")
//        group.enter()
//        currentUserReference.setValue(challenge.dictionaryRepresentation) { (error, _) in
//            completionError = error
//            group.leave()
//        }
//        
//        let opponentScoreReference = defaultDatabaseReference.child("\(opponentID)/challenges/sent/\(challenge.id)")
//        group.enter()
//        let opponentChallenge = Challenge(id: challenge.id, opponentID: currentUser.uid, selfInitiated: true, score: challenge.score)
//        opponentScoreReference.setValue(opponentChallenge.dictionaryRepresentation) { (error, _) in
//            completionError = error
//            group.leave()
//        }
//        
//        group.notify(queue: DispatchQueue.main) {
//            completion(completionError)
//        }
    }
}
