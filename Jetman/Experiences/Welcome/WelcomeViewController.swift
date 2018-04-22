//
//  WelcomeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/7/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol WelcomeViewEmbeddedControllerDelegate: class {
    func embeddedControllerShouldDismiss()
}

final class WelcomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private var interactor: WelcomeViewInteractor!
    @IBOutlet private var gameplayButton: UIButton!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentDeferredViewController), name: Constants.Notifications.challengeReceived, object: nil)
        
        // Move the embedded controller container view off-screen initially
        embeddedControllerContainerView.transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentDeferredViewController()
    }

    @IBAction func showSettingsView(_ sender: UIButton) {
        guard let settingsView = UIStoryboard(name: "SettingsView", bundle: nil).instantiateInitialViewController() as? SettingsViewController else { return }
        settingsView.delegate = self
        castedEmbeddedController?.addChild(settingsView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func showStatsView(_ sender: UIButton) {
        guard let statsView = UIStoryboard(name: "StatsView", bundle: nil).instantiateInitialViewController() as? StatsViewController else { return }
        statsView.delegate = self
        castedEmbeddedController?.addChild(statsView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func showNewChallengeView(_ sender: UIButton) {
        guard let newChallengeView = UIStoryboard(name: "NewChallengeView", bundle: nil).instantiateInitialViewController() as? NewChallengeViewController else { return }
        newChallengeView.delegate = self
        castedEmbeddedController?.addChild(newChallengeView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func showMyChallengesView(_ sender: UIButton) {
        guard let myChallengesView = UIStoryboard(name: "MyChallengesView", bundle: nil).instantiateInitialViewController() as? MyChallengesViewController else { return }
        myChallengesView.delegate = self
        castedEmbeddedController?.addChild(myChallengesView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedController" {
            embeddedController = segue.destination
        } else if segue.identifier == "showGameplay" {
            guard let gameplayVC = segue.destination as? GameplayViewController else { return }
            if let challenge = sender as? Challenge {
                gameplayVC.challenge = challenge
            }
        }
    }
}

// MARK: - Private
private extension WelcomeViewController {
    @objc func presentDeferredViewController() {
        guard let vc = AppDelegate.shared.viewControllerToPresent else { return }
        
        if let challengeResponseVC = vc as? ChallengeResponseViewController {
            challengeResponseVC.interactor.delegate = interactor
        }
        
        present(vc, animated: true, completion: nil)
        AppDelegate.shared.viewControllerToPresent = nil
    }
}

// MARK: - Animation
private extension WelcomeViewController {
    
    func animateEmbeddedControllerVisibility(isVisible: Bool, completion: (() -> Void)?) {
        let transform: CGAffineTransform
        let dimmingViewAlpha: CGFloat
        if isVisible {
            transform = CGAffineTransform.identity
            dimmingViewAlpha = 0.5
        } else {
            transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
            dimmingViewAlpha = 0.0
        }

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let this = self else { return }
            this.embeddedControllerContainerView.transform = transform
            this.dimmingView.alpha = dimmingViewAlpha
        }) { (_) in
            completion?()
        }
    }
}

// MARK: - Embedded controller delegate
extension WelcomeViewController: WelcomeViewEmbeddedControllerDelegate {
    func embeddedControllerShouldDismiss() {
        animateEmbeddedControllerVisibility(isVisible: false) { [weak self] in
            guard let this = self else { return }
            this.castedEmbeddedController?.removeChildren()
        }
    }
}
