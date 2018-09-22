//
//  GameplayViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase

protocol GameplayDelegate: class {
    func didTapPlayAgain()
    func didTapContinuePlaying(carryOverScore: Int)
}

class GameplayViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var scoreNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    lazy var endOfGameView: EndOfGameViewController? = {
        guard let endOfGameView = UIStoryboard(name: "EndOfGameView", bundle: nil).instantiateInitialViewController() as? EndOfGameViewController else { return nil }
        guard let scoreKeeper = (skView.scene as? GameplayScene)?.scoreKeeper else { return nil }
        
        if scoreKeeper.currentScore > GameSession.shared.highScore ?? 0 {
            GameSession.shared.highScore = scoreKeeper.currentScore
            CloudKitManager.shared.updateHighScore(scoreKeeper.currentScore, completion: nil)
        }
        
        endOfGameView.loadView()
        endOfGameView.configureFor(score: scoreKeeper.currentScore, highScore: GameSession.shared.highScore ?? 0)
        endOfGameView.delegate = self
        
        return endOfGameView
    }()
    
    lazy var endOfLevelView: EndOfLevelViewController? = {
        guard let endOfLevelView = UIStoryboard(name: "EndOfLevelView", bundle: nil).instantiateInitialViewController() as? EndOfLevelViewController else { return nil }
        guard let scoreKeeper = (skView.scene as? GameplayScene)?.scoreKeeper else { return nil }
        
        if scoreKeeper.currentScore > GameSession.shared.highScore ?? 0 {
            GameSession.shared.highScore = scoreKeeper.currentScore
            CloudKitManager.shared.updateHighScore(scoreKeeper.currentScore, completion: nil)
        }
        
        endOfLevelView.loadView()
        endOfLevelView.configureFor(score: scoreKeeper.currentScore,
                                    highScore: GameSession.shared.highScore ?? 0,
                                    nextLevel: GameSession.shared.levelManager.currentLevel)
        endOfLevelView.delegate = self
        
        return endOfLevelView
    }()
    
    weak var delegate: GameplayDelegate?
    
    var challenge: Challenge?
    var scoreKeeper: ScoreKeeper? {
        return (skView.scene as? GameplayScene)?.scoreKeeper
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.frame = view.frame
        let scene = GameplayScene(size: view.frame.size)
        scene.viewController = self
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        (skView.scene as? GameplayScene)?.gameplayDelegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func animateEmbeddedControllerVisibility(isVisible: Bool, playerDied: Bool) {
        guard let viewToPresent: UIViewController = playerDied ? endOfGameView : endOfLevelView else { return }
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.alpha = 0
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addChildViewController(viewToPresent)
        viewToPresent.didMove(toParentViewController: self)
        containerView.addSubview(viewToPresent.view)
        viewToPresent.view.frame = containerView.frame
        
        let yTranslation = (containerView.frame.height + (view.frame.maxY - containerView.frame.maxY)) * 1.2
        containerView.transform = CGAffineTransform(translationX: 0, y: yTranslation)
        containerView.alpha = 1
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension GameplayViewController: GameplaySceneDelegate {
    func gameplaySceneDidUpdateScore(newScore: Int) {
        guard
            let displayedScore = scoreLabel.text,
            let displayedScoreInt = Int(displayedScore),
            newScore != displayedScoreInt else { return }
        
        scoreLabel.text = "\(newScore)"
    }
    
    func gameplayDidEnd(playerDied: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let this = self else { return }
            this.animateEmbeddedControllerVisibility(isVisible: true, playerDied: playerDied)
        }
    }
}

extension GameplayViewController: EndOfGameDelegate {
    func didTapGoToStats() {
        return
    }
    
    func didTapGoToHome() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapPlayAgain() {
        delegate?.didTapPlayAgain()
    }
}

extension GameplayViewController: EndOfLevelDelegate {
    func didTapContinuePlaying() {
        guard let scoreKeeper = scoreKeeper else {
            fatalError("Scene must be available still to find the current score.")
        }
        delegate?.didTapContinuePlaying(carryOverScore: scoreKeeper.currentScore)
    }
}
