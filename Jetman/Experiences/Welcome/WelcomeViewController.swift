//
//  WelcomeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/7/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import GameKit
import FirebaseAuth

final class WelcomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private var interactor: WelcomeViewInteractor!
    @IBOutlet private var gameplayButton: UIButton!
    @IBOutlet private var challengeButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var dimmingView: UIView!
    @IBOutlet weak var embeddedControllerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentGameCenterVCIfNeeded), name: Constants.Notifications.gameCenterVCReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFeatureAccess), name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName, object: nil)
        
        updateFeatureAccess()
        prepareEmbeddedController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentGameCenterVCIfNeeded()
    }

    @objc func presentGameCenterVCIfNeeded() {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let gameCenterVC = appDelegate.gameCenterVC else { return }
        
        present(gameCenterVC, animated: true, completion: nil)
    }
    
    @objc func updateFeatureAccess() {
        gameplayButton.isEnabled = true
        challengeButton.isEnabled = true
        leaderboardButton.isEnabled = true
    }
    
    private func prepareEmbeddedController() {
        embeddedControllerContainerView.transform = CGAffineTransform(translationX: 0, y: embeddedControllerContainerView.frame.size.height)
    }
}
