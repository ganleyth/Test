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
    
    private var embeddedController: UIViewController?
    private var castedEmbeddedController: WelcomeViewEmbeddedController? {
        return embeddedController as? WelcomeViewEmbeddedController
    }
    
    private var containerViewYTranslation: CGFloat {
        return view.frame.size.height - embeddedControllerContainerView.frame.minY
    }
    
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
    
    @IBAction func showSettingsView(_ sender: UIButton) {
        guard let settingsView = UIStoryboard(name: "SettingsView", bundle: nil).instantiateInitialViewController() as? SettingsViewController else { return }
        castedEmbeddedController?.addChild(settingsView)
        animateEmbeddedControllerVisibility(isVisible: true)
    }
    
    private func prepareEmbeddedController() {
        embeddedControllerContainerView.transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedController" {
            embeddedController = segue.destination
        }
    }
}

// MARK: - Animation
private extension WelcomeViewController {
    
    func animateEmbeddedControllerVisibility(isVisible: Bool) {
        let transform: CGAffineTransform
        let dimmingViewAlpha: CGFloat
        if isVisible {
            transform = CGAffineTransform.identity
            dimmingViewAlpha = 0.6
        } else {
            transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
            dimmingViewAlpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: { [weak self] in
            guard let this = self else { return }
            this.embeddedControllerContainerView.transform = transform
            this.dimmingView.alpha = dimmingViewAlpha
        }, completion: nil)
    }
}
