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
    @IBOutlet fileprivate var tapPlateLeft: UIView!
    @IBOutlet fileprivate var tapPlateRight: UIView!
    
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
        
        [tapPlateLeft, tapPlateRight].forEach {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(askDelegateToDismiss))
            $0?.addGestureRecognizer(tapRecognizer)
        }
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        askDelegateToDismiss()
    }
    
    @objc private func askDelegateToDismiss() {
        CloudKitManager.shared.cancelOperation(for: .leaderboardFetch)
        delegate?.embeddedControllerShouldDismiss()
    }
}
