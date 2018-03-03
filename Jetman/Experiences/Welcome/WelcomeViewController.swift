//
//  WelcomeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/7/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import GameKit

final class WelcomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private var interactor: WelcomeViewInteractor!
    @IBOutlet private var gameplayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentGameCenterVCIfNeeded), name: Constants.Notifications.gameCenterVCReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unlockApp), name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName, object: nil)
        
        unlockApp()
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
    
    @objc func unlockApp() {
        gameplayButton.isEnabled = MemberService.shared.localPlayerIsAuthenticated
    }
}
