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
        
        // Move the embedded controller container view off-screen initially
        embeddedControllerContainerView.transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
    }

    @objc func presentGameCenterVCIfNeeded() {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let gameCenterVC = appDelegate.gameCenterVC else { return }
        
        present(gameCenterVC, animated: true, completion: nil)
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
        }
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
