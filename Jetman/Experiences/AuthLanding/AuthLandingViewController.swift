//
//  AuthLandingViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class AuthLandingViewController: UIViewController {

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
