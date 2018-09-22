//
//  EndOfLevelViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/5/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

protocol EndOfLevelDelegate: class {
    func didTapContinuePlaying()
}

class EndOfLevelViewController: UIViewController {
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var highScoreLabel: UILabel!
    @IBOutlet private weak var nextLevelLabel: UILabel!
    
    weak var delegate: EndOfLevelDelegate?
    
    func configureFor(score: Int, highScore: Int, nextLevel: Int) {
        scoreLabel.text = "\(score)"
        highScoreLabel.text = "\(highScore)"
        nextLevelLabel.text = "\(nextLevel)"
    }
    
    @IBAction func continuePlaying(_ sender: UIButton) {
        delegate?.didTapContinuePlaying()
    }
}
