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
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.frame = view.frame
        let scene = GameplayScene(size: view.frame.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        (skView.scene as? GameplayScene)?.gameplayDelegate = self
        
        configureSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func configureSubviews() {
        scoreNameLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        scoreLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
    }

    // Temporary play again button handling
    @IBAction func playAgain(_ sender: UIButton) {
        (UIApplication.shared.delegate as? AppDelegate)?.reset()
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
        playAgainButton.isHidden = false
    }
}
