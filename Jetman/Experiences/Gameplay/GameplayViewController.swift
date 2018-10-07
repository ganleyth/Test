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
    func didTapContinuePlaying()
}

class GameplayViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var coinsToFireModeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    lazy var endOfGameView: EndOfGameViewController? = {
        guard let endOfGameView = UIStoryboard(name: "EndOfGameView", bundle: nil).instantiateInitialViewController() as? EndOfGameViewController else { return nil }
        
        let scoreKeeper = GameSession.shared.scoreKeeper
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
        let scoreKeeper = GameSession.shared.scoreKeeper
        
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
        configureSubviews()
        updateScoreLabels()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateScoreLabels), name: Constants.Notifications.scoreDidUpdate, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateHighScoreLabelAlpha()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Private helpers
private extension GameplayViewController {
    
    func configureSubviews() {
        scoreLabel.text = "\(GameSession.shared.scoreKeeper.currentScore)"
        highScoreLabel.text = "High: \(GameSession.shared.highScore ?? 0)"
        levelLabel.text = "Level: \(GameSession.shared.levelManager.currentLevel)"
    }
    
    func animateEmbeddedControllerVisibility(isVisible: Bool, playerDied: Bool) {
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
    
    func animateHighScoreLabelAlpha() {
        UIView.animate(withDuration: 1, delay: 1, animations: { [weak self] in
            self?.highScoreLabel.alpha = 0
            self?.levelLabel.alpha = 0
        }) { [weak self] (_) in
            self?.highScoreLabel.removeFromSuperview()
            self?.levelLabel.removeFromSuperview()
        }
    }
}

extension GameplayViewController: GameplaySceneDelegate {
    @objc func updateScoreLabels() {
        scoreLabel.text = "\(GameSession.shared.scoreKeeper.currentScore)"
        coinsToFireModeLabel.text = "\(GameSession.shared.scoreKeeper.coinsLeftToFireMode)"
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
        dismiss(animated: true) {
            GameSession.shared.scoreKeeper.reset(didGameEnd: true)
        }
    }
    
    func didTapPlayAgain() {
        delegate?.didTapPlayAgain()
    }
}

extension GameplayViewController: EndOfLevelDelegate {
    func didTapContinuePlaying() {
        delegate?.didTapContinuePlaying()
    }
}
