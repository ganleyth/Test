//
//  NewUserViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField! {
        didSet {
            guard let layer = usernameTextField.layer.sublayers?.first else { return }
            layer.shadowColor = UIColor(red: 101.0/255.0, green: 100.0/255.0, blue: 101.0/255.0, alpha: 1.0).cgColor
            layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
}
