//
//  NewChallengeInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import MessageUI
import Messages

class NewChallengeInteractor: Interactor {
    
    private var challenge: Challenge?
    
    @IBAction func challengeContact(_ sender: UIButton) {
//        guard let currentUser = FirebaseManager.shared.loginManager.currentUser else { return }
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        let challenge = Challenge(id: UUID().uuidString, opponentID: nil, selfInitiated: true)
        self.challenge = challenge
//        messageController.message = MessagesChallenge(challengeID: challenge.id, senderID: currentUser.uid)
        
        viewController.present(messageController, animated: true, completion: nil)
    }
}

// Message compose delegate
extension NewChallengeInteractor: MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        defer { controller.dismiss(animated: true, completion: nil) }
        guard let challenge = challenge else { return }
        if result == .sent {
            FirebaseManager.shared.challengeManager.initiateContactChallenge(challenge) { [weak self] (error) in
                guard let this = self else { return }
                let title: String
                let message: String
                if error != nil {
                    title = "Error sending challenge"
                    message = "Could not successfully send challenge. Please try again."
                } else {
                    title = "Challenge Sent!"
                    message = "The challenge has been successfully sent!"
                }
                
                DispatchQueue.main.async {
                    this.viewController.presentInfoAlertWith(title: title, message: message)
                }
            }
        }
    }
}
