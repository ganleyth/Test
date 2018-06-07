//
//  EndOfGameViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/5/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class EndOfGameViewController: UIViewController {
    @IBOutlet fileprivate var scoreStackView: UIStackView!
    @IBOutlet fileprivate var highScoreStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureFor(score: Int, highScore: Int) {
        let scoreView = score.phosphateRepresentationImage
        let highScoreView = highScore.phosphateRepresentationImage
        
        scoreStackView.addArrangedSubview(scoreView)
        highScoreStackView.addArrangedSubview(highScoreView)
    }
}
