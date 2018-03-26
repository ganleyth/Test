//
//  SignInInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

final class SignInInteractor: Interactor {
    private var signInViewController: SignInViewController? {
        return viewController as? SignInViewController
    }
}

// MARK: - Table view data source
extension SignInInteractor: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let signInVC = signInViewController,
            let cell = tableView.dequeueReusableCell(withIdentifier: "signupCell", for: indexPath) as? SignInTableViewCell else { return SignInTableViewCell() }
        cell.delegate = self
        cell.configure(for: signInVC.style)
        return cell
    }
}

// MARK: - Sign up delegate
extension SignInInteractor: SignInDelegate {
    
    func signInCellDidTapSignupWith(email: String, password: String) {
        FirebaseManager.shared.loginManager.signupUserWith(email: email, password: password) { [weak self] (error) in
            guard let this = self else { return }
            if let error = error {
                this.viewController.presentInfoAlertWith(title: "Signup Error", message: error.localizedDescription)
            }
            
            this.viewController?.performSegue(withIdentifier: "showWelcomeView", sender: this.viewController)
        }
    }
    
    func signInCellDidRegisterInvalidCredentials() {
        let title = "Invalid Credentials"
        let message = "Please enter a valid Email and password"
        viewController.presentInfoAlertWith(title: title, message: message)
    }
}

