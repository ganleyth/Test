//
//  SignInViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet var interactor: SignInInteractor!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = interactor
        
        tableView.rowHeight = view.frame.size.height
    }
}
