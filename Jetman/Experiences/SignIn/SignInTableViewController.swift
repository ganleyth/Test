//
//  SignInTableViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/1/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

enum SignInStyle {
    case signup
    case signIn
}

class SignInTableViewController: UITableViewController {

    @IBOutlet fileprivate var interactor: SignInInteractor!
    
    var style = SignInStyle.signIn {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = view.frame.size.height
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "signupCell", for: indexPath) as? SignInTableViewCell else { return SignInTableViewCell() }
        cell.delegate = interactor
        cell.configure(for: style)
        return cell
    }
}
