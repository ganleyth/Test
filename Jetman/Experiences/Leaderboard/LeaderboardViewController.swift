//
//  LeaderboardViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 7/1/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet fileprivate var interactor: LeaderboardInteractor!
    @IBOutlet fileprivate var tableView: UITableView!
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 40
        
        interactor.uiRefresh = { [weak self] in
            guard let this = self else { return }
            this.tableView.reloadData()
        }
        interactor.fetchLeaders()
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
