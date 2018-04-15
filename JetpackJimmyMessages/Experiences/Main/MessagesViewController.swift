//
//  MessagesViewController.swift
//  JetpackJimmyMessages
//
//  Created by Thomas Ganley on 4/14/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        if conversation.selectedMessage != nil {
            guard let challengeResponseVC = UIStoryboard(name: "ChallengeResponseView", bundle: nil).instantiateInitialViewController() as? ChallengeResponseViewController else { return }
            presentViewController(challengeResponseVC)
        } else {
            guard let defaultCompactVC = UIStoryboard(name: "DefaultCompactView", bundle: nil).instantiateInitialViewController() as? DefaultCompactViewController else { return }
            presentViewController(defaultCompactVC)
        }
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
        
        guard
            let selectedMessage = conversation.selectedMessage,
            let challengeResponseVC = UIStoryboard(name: "ChallengeResponseView", bundle: nil).instantiateInitialViewController() as? ChallengeResponseViewController else { return }
        presentViewController(challengeResponseVC)
    }
}

// MARK: - Private
private extension MessagesViewController {
    
    func presentViewController(_ viewController: UIViewController) {
        removeAllChildViewControllers()
        addChildViewController(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.removeFromParentViewController()
            child.view.removeFromSuperview()
        }
    }
}
