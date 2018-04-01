//
//  AuthLandingViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthLandingViewController: UIViewController {
    
    private var stateChangeHandler: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateChangeHandler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let this = self else { return }
            if user != nil { this.performSegue(withIdentifier: "showWelcomeView", sender: nil) }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = stateChangeHandler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destiationVC = segue.destination as? SignInViewController else { return }
        
        switch segue.identifier {
        case "showSignUpView"?:
            destiationVC.style = .signup
        case "showSignInView"?:
            destiationVC.style = .signIn
        default:
            return
        }
    }
}
