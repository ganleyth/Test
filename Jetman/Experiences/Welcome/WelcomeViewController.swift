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
    
    private var authStateChangeHandler: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentGameCenterVCIfNeeded), name: Constants.Notifications.gameCenterVCReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFeatureAccess), name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName, object: nil)
        
        updateFeatureAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStateChangeHandler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            //
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentGameCenterVCIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = authStateChangeHandler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
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
}
