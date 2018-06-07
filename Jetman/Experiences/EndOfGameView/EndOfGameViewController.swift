//
//  EndOfGameViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/5/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

protocol EndOfGameDelegate: class {
    func didTapGoToStats()
    func didTapGoToHome()
    func didTapPlayAgain()
}

class EndOfGameViewController: UIViewController {
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    
    weak var delegate: EndOfGameDelegate?
    
    func configureFor(score: Int, highScore: Int) {
        scoreLabel.text = "\(score)"
        highScoreLabel.text = "\(highScore)"
    }
    
    @IBAction func goToStats(_ sender: UIButton) {
        delegate?.didTapGoToStats()
    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        delegate?.didTapGoToHome()
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        delegate?.didTapPlayAgain()
    }
}
