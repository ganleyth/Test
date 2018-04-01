//
//  StatsViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var interactor: StatsInteractor!
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = interactor
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
