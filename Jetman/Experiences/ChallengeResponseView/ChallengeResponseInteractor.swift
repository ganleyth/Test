//
//  ChallengeResponseInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/21/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import UIKit

class ChallengeResponseInteractor: Interactor {
    
    private var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    var challengeResponseVC: ChallengeResponseViewController? {
        return viewController as? ChallengeResponseViewController
    }
    
    @IBAction func acceptChallenge(sender: UIButton) {
        guard let challenge = challengeResponseVC?.challenge else { return }
        FirebaseManager.shared.friendManager.verifyFriendStatus(forSender: challenge.opponentID) { (isFriend) in
            if !isFriend {
                let friend = Friend(id: challenge.opponentID, recordAgainst: "0-0")
                FirebaseManager.shared.friendManager.addFriend(friend)
            }
        }
    }
    
    @IBAction func declineChallenge(sender: UIButton) {
        
    }
}
