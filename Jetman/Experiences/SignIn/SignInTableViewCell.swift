//
//  SignInTableViewCell.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

protocol SignInDelegate: class {
    func signInCellDidTapSignupWith(displayName: String, email: String, password: String)
    func signInCellDidTapSignInWith(email: String, password: String)
    func signInCellDidRegisterInvalidCredentials()
}

class SignInTableViewCell: UITableViewCell {

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet private var displayNameStackView: UIStackView!
    @IBOutlet private var displayNameTextField: UITextField!
    
    var style: SignInStyle?
    
    weak var delegate: SignInDelegate?
    
    func configure(for style: SignInStyle) {
        switch style {
        case .signup:
            signInButton.setTitle("Create Account", for: UIControlState())
            displayNameStackView.isHidden = false
        case .signIn:
            signInButton.setTitle("Sign In", for: UIControlState())
            displayNameStackView.isHidden = true
        }
        
        self.style = style
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                delegate?.signInCellDidRegisterInvalidCredentials()
                return
        }
        
        switch style {
        case .signup?:
            guard let displayName = displayNameTextField.text, !displayName.isEmpty else {
                delegate?.signInCellDidRegisterInvalidCredentials()
                return
            }
            delegate?.signInCellDidTapSignupWith(displayName: displayName, email: email, password: password)
        case .signIn?:
            delegate?.signInCellDidTapSignInWith(email: email, password: password)
        default:
            delegate?.signInCellDidTapSignInWith(email: email, password: password)
        }
    }
}

