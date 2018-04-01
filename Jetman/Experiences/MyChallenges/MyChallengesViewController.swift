//
//  MyChallengesViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class MyChallengesViewController: UIViewController {

    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var interactor: MyChallengesInteractor!
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = interactor
        tableView.delegate = interactor
    }
    
    @IBAction func changeMailboxSelection(_ sender: UISegmentedControl) {
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
