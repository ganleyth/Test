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
    
    private var defaultCompactVC: DefaultCompactViewController? {
        return UIStoryboard(name: "DefaultCompactView", bundle: nil).instantiateInitialViewController() as? DefaultCompactViewController
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        if let selectedMessage = conversation.selectedMessage {
            guard let url = selectedMessage.url else { return }
            extensionContext?.open(url) { _ in }
        } else {
            guard let defaultCompactVC = defaultCompactVC else { return }
            presentViewController(defaultCompactVC)
        }
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
        guard let url = message.url else { return }
        extensionContext?.open(url) { _ in }
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
