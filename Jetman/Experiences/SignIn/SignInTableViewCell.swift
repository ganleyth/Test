//
//  SignInTableViewCell.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

protocol SignInDelegate: class {
    func signInCellDidTapSignupWith(email: String, password: String)
    func signInCellDidRegisterInvalidCredentials()
}

class SignInTableViewCell: UITableViewCell {
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    weak var delegate: SignInDelegate?
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                delegate?.signInCellDidRegisterInvalidCredentials()
                return
        }
        
        delegate?.signInCellDidTapSignupWith(email: email, password: password)
    }
}

