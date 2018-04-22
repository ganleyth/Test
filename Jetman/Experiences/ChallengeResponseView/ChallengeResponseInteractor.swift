//
//  ChallengeResponseInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/21/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import UIKit

protocol ChallengeResponseDelegate: class {
    func challengeWasAccepted(challenge: Challenge)
}

class ChallengeResponseInteractor: Interactor {
    
    weak var delegate: ChallengeResponseDelegate?
    
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
        guard let challenge = challengeResponseVC?.challenge,
            let opponentID = challenge.opponentID else { return }
        
        DispatchQueue.global(qos: .background).async {
            FirebaseManager.shared.friendManager.verifyFriendStatus(forSender: opponentID) { (isFriend) in
                if !isFriend {
                    let friend = Friend(id: opponentID, recordAgainst: "0-0")
                    FirebaseManager.shared.friendManager.addFriend(friend)
                }
            }
        }
        
        viewController.dismiss(animated: true) { [weak self] in
            guard let this = self else { return }
            this.delegate?.challengeWasAccepted(challenge: challenge)
        }
    }
    
    @IBAction func declineChallenge(sender: UIButton) {
        
    }
}
