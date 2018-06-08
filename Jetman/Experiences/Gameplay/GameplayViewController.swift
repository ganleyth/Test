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

protocol GameplayDelegate: class {
    func didTapPlayAgain()
}

class GameplayViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var scoreNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet fileprivate var containerView: UIView!
    
    var embeddedController: UIViewController?
    var castedEmbeddedController: EmbeddedController? {
        return embeddedController as? EmbeddedController
    }
    
    weak var delegate: GameplayDelegate?
    
    var challenge: Challenge?
    private lazy var containerViewYTranslation: CGFloat = {
        return (containerView.frame.height + (view.frame.maxY - containerView.frame.maxY)) * 1.2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.frame = view.frame
        let scene = GameplayScene(size: view.frame.size)
        scene.viewController = self
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        (skView.scene as? GameplayScene)?.gameplayDelegate = self
        
        containerView.transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
        
        configureSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func configureSubviews() {
        scoreNameLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        scoreLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
    }
    
    private func animateEmbeddedControllerVisibility(isVisible: Bool) {
        let transform: CGAffineTransform
        if isVisible {
            transform = CGAffineTransform.identity
        } else {
            transform = CGAffineTransform(translationX: 0, y: containerViewYTranslation)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let this = self else { return }
            this.containerView.transform = transform
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedController" {
            embeddedController = segue.destination
        }
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
    
    func gameplayDidEnd() {
        guard let endOfGameView = UIStoryboard(name: "EndOfGameView", bundle: nil).instantiateInitialViewController() as? EndOfGameViewController else {
            assertionFailure("Could not instantiate end of game view")
            return
        }
        guard let scoreKeeper = (skView.scene as? GameplayScene)?.scoreKeeper else {
            assertionFailure("Couldn't get scorekeeper")
            return
        }
        
        GameSession.shared.highScore = max(scoreKeeper.currentScore, GameSession.shared.highScore ?? 0)
        
        endOfGameView.loadView()
        endOfGameView.configureFor(score: scoreKeeper.currentScore, highScore: GameSession.shared.highScore ?? 0)
        endOfGameView.delegate = self
        castedEmbeddedController?.addEmbeddedChild(endOfGameView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let this = self else { return }
            this.animateEmbeddedControllerVisibility(isVisible: true)
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
