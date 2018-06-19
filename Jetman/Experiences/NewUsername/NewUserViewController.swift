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
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    private func assignNewUsername(_ username: String) {
        CloudKitManager.shared.checkIsUsernameAvailable(username: username) { [weak self] (isAvailable, error) in
            guard let this = self else { return }
            guard error == nil else {
                this.presentInfoAlertWith(title: "Oops!", message: "Couldn't connect to the network. Try again!")
                return
            }
            
            CloudKitManager.shared.setUsername(username, with: { [weak self] (success) in
                guard let this = self else { return }
                if success {
                    let alertController = UIAlertController(title: "Great!", message: "Your username has been saved", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
                        guard let this = self else { return }
                        this.delegate?.embeddedControllerShouldDismiss()
                    })
                    alertController.addAction(okAction)
                    this.present(alertController, animated: true, completion: nil)
                } else {
                    this.presentInfoAlertWith(title: "Oops!", message: "Could not save your username. Try again!")
                }
            })
        }
    }
}

extension NewUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        textField.text = text.uppercased()
        usernameTextField.resignFirstResponder()
        assignNewUsername(text.uppercased())
        return true
    }
}
