//
//  NewChallengeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import MessageUI

class NewChallengeViewController: UIViewController {
    
    @IBOutlet fileprivate var interactor: NewChallengeInteractor!
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
