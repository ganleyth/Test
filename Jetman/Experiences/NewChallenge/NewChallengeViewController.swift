//
//  NewChallengeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import MessageUI

class NewChallengeViewController: UIViewController {
    
    @IBOutlet fileprivate var interactor: NewChallengeInteractor!
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func challengeContact(_ sender: UIButton) {
        guard let currentUser = FirebaseManager.shared.loginManager.currentUser else { return }
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = interactor
        messageController.message = MessagesChallenge(senderID: currentUser.uid)
        present(messageController, animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
