//
//  WelcomeViewInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit
import GameKit

class WelcomeViewInteractor: Interactor {
    
    var welcomeViewController: WelcomeViewController? {
        return viewController as? WelcomeViewController
    }
}

extension WelcomeViewInteractor: GKGameCenterControllerDelegate, UINavigationControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension WelcomeViewInteractor: ChallengeResponseDelegate {
    func challengeWasAccepted(challenge: Challenge) {
        viewController.performSegue(withIdentifier: "showGameplay", sender: challenge)
    }
}
