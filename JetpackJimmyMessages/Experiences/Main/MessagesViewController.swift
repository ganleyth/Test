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
        presentViewController(for: conversation, with: presentationStyle, forReceivedMessage: false)
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        super.didReceive(message, conversation: conversation)
    }
}

// MARK: - Private
private extension MessagesViewController {
    
    func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle, forReceivedMessage: Bool) {
        removeAllChildViewControllers()
        
        guard let defaultCompactVC = UIStoryboard(name: "DefaultCompactView", bundle: nil).instantiateInitialViewController() as? DefaultCompactViewController else { return }
        
        addChildViewController(defaultCompactVC)
        defaultCompactVC.view.frame = view.frame
        view.addSubview(defaultCompactVC.view)
        defaultCompactVC.didMove(toParentViewController: self)
    }
    
    func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.removeFromParentViewController()
            child.view.removeFromSuperview()
        }
    }
}
