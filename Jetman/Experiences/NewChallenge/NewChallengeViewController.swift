//
//  NewChallengeViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class NewChallengeViewController: UIViewController {
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var interactor: NewChallengeInteractor!
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = interactor
        FirebaseManager.shared.friendManager.fetchContacts { [weak self] (error) in
            guard let this = self else { return }
            if let error = error {
                this.presentInfoAlertWith(title: "Could not access contacts", message: error.localizedDescription)
                return
            }
            
            this.tableView.reloadData()
        }
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
