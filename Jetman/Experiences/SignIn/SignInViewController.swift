//
//  SignInViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

enum SignInStyle {
    case signup
    case signIn
}

class SignInViewController: UIViewController {
    
    @IBOutlet var interactor: SignInInteractor!
    @IBOutlet weak var tableView: UITableView!
    
    var style = SignInStyle.signIn {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = interactor
        
        tableView.rowHeight = view.frame.size.height
    }
}
