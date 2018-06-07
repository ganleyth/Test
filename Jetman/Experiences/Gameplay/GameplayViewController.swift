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

class GameplayViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var scoreNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet fileprivate var containerView: UIView!
    
    var challenge: Challenge?
    private lazy var containerViewYTranslation: CGFloat = {
        return containerView.frame.height + (view.frame.maxY - containerView.frame.maxY)
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
        let endOfGameView = UIStoryboard(name: "EndOfGameView", bundle: nil).instantiateInitialViewController()
    }
}
