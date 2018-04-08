//
//  ChallengeResponseViewController.swift
//  MessagesExtension
//
//  Created by Thomas Ganley on 4/4/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class ChallengeResponseViewController: UIViewController {
    
    @IBAction func acceptChallenge(_ sender: UIButton) {
    }
    
    @IBAction func declineChallenge(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
