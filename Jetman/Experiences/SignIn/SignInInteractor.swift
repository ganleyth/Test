//
//  SignInInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

final class SignInInteractor: Interactor {
    private var signInTableViewController: SignInTableViewController? {
        return viewController as? SignInTableViewController
    }
}

// MARK: - Sign up delegate
extension SignInInteractor: SignInDelegate {
    
    func signInCellDidTapSignupWith(displayName: String, email: String, password: String) {
        FirebaseManager.shared.loginManager.signupUserWith(email: email, password: password) { [weak self] (error) in
            guard let this = self else { return }
            if let error = error {
                this.viewController.presentInfoAlertWith(title: "Signup Error", message: error.localizedDescription)
            }
            
            FirebaseManager.shared.loginManager.setUserDisplayName(to: displayName, completion: { (_) in })
            
            this.viewController.performSegue(withIdentifier: "showWelcomeView", sender: nil)
        }
    }
    
    func signInCellDidTapSignInWith(email: String, password: String) {
        FirebaseManager.shared.loginManager.signInUserWith(email: email, password: password) { [weak self] (error) in
            guard let this = self else { return }
            if let error = error {
                this.viewController.presentInfoAlertWith(title: "Sign In Error", message: error.localizedDescription)
            }
            
            this.viewController.performSegue(withIdentifier: "showWelcomeView", sender: nil)
        }
    }
    
    func signInCellDidRegisterInvalidCredentials() {
        let title = "Invalid Credentials"
        let message = "Please enter a valid Email and password"
        viewController.presentInfoAlertWith(title: title, message: message)
    }
}

