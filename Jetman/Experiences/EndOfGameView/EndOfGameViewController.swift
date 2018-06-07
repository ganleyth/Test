//
//  EndOfGameViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/5/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class EndOfGameViewController: UIViewController {
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    
    func configureFor(score: Int, highScore: Int) {
        scoreLabel.text = "\(score)"
        highScoreLabel.text = "\(highScore)"
    }
}
