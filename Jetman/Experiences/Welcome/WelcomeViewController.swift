//
//  WelcomeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/7/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

protocol WelcomeViewEmbeddedControllerDelegate: class {
    func embeddedControllerShouldDismiss()
}

final class WelcomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private var interactor: WelcomeViewInteractor!
    @IBOutlet private var gameplayButton: UIButton!
    @IBOutlet weak var dimmingView: UIView!
    @IBOutlet weak var embeddedControllerContainerView: UIView!
    @IBOutlet fileprivate var bannerView: GADBannerView!
    
    private var embeddedController: UIViewController?
    private var castedEmbeddedController: EmbeddedController? {
        return embeddedController as? EmbeddedController
    }
    
    private var containerViewYTranslation: CGFloat {
        return view.frame.size.height - embeddedControllerContainerView.frame.minY + 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentDeferredViewController), name: Constants.Notifications.challengeReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentNewUsernameEntryView), name: Constants.Notifications.requestNewUsernameEntry, object: nil)
        
        // Move the embedded controller container view off-screen initially
        embeddedControllerContainerView.transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation + 60)
        
        configureBannerAd()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(embeddedControllerShouldDismiss))
        dimmingView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = GameSession.shared.currentUser, user.username == nil {
            presentNewUsernameEntryView()
        }
    }

    @IBAction func showSettingsView(_ sender: UIButton) {
        guard let settingsView = UIStoryboard(name: "SettingsView", bundle: nil).instantiateInitialViewController() as? SettingsViewController else { return }
        settingsView.delegate = self
        castedEmbeddedController?.addEmbeddedChild(settingsView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func showLeaderboardView(_ sender: UIButton) {
        guard let leaderboardView = UIStoryboard(name: "LeaderboardView", bundle: nil).instantiateInitialViewController() as? LeaderboardViewController else { return }
        leaderboardView.delegate = self
        castedEmbeddedController?.addEmbeddedChild(leaderboardView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func showNewChallengeView(_ sender: UIButton) {
        guard let newChallengeView = UIStoryboard(name: "NewChallengeView", bundle: nil).instantiateInitialViewController() as? NewChallengeViewController else { return }
        newChallengeView.delegate = self
        castedEmbeddedController?.addEmbeddedChild(newChallengeView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func showMyChallengesView(_ sender: UIButton) {
        guard let myChallengesView = UIStoryboard(name: "MyChallengesView", bundle: nil).instantiateInitialViewController() as? MyChallengesViewController else { return }
        myChallengesView.delegate = self
        castedEmbeddedController?.addEmbeddedChild(myChallengesView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
//        try? Auth.auth().signOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedController" {
            embeddedController = segue.destination
        } else if segue.identifier == "showGameplay" {
            guard let gameplayVC = segue.destination as? GameplayViewController else { return }
            gameplayVC.delegate = self
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
    
    func configureBannerAd() {
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3667026795210788/2461550614"
    }
    
    @objc func presentNewUsernameEntryView() {
        guard
            let ec = embeddedController,
            ec.childViewControllers.isEmpty,
            let newUserView = UIStoryboard(name: "NewUsernameView", bundle: nil).instantiateInitialViewController() as? NewUserViewController else { return }
        newUserView.delegate = self
        castedEmbeddedController?.addEmbeddedChild(newUserView)
        animateEmbeddedControllerVisibility(isVisible: true, completion: nil)
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
    @objc func embeddedControllerShouldDismiss() {
        if let firstChildVC = embeddedController?.childViewControllers.first {
            switch firstChildVC {
            case _ as LeaderboardViewController:
                CloudKitManager.shared.cancelOperation(for: .leaderboardFetch)
            default:
                break
            }
        }
        animateEmbeddedControllerVisibility(isVisible: false) { [weak self] in
            guard let this = self else { return }
            this.castedEmbeddedController?.removeChildren()
        }
    }
}

extension WelcomeViewController: GameplayDelegate {
    func didTapPlayAgain() {
        resetGameplay(carryOverScore: nil)
    }
    
    func didTapContinuePlaying(carryOverScore: Int) {
        resetGameplay(carryOverScore: carryOverScore)
    }
    
    private func resetGameplay(carryOverScore: Int?) {
        guard let pvc = presentedViewController else { return }
        pvc.dismiss(animated: false) {
            self.performSegue(withIdentifier: "showGameplay", sender: carryOverScore)
        }
    }
}
