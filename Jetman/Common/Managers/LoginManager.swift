//
//  LoginManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseCore

class LoginManager: Manager {
    
    func signupUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            defer { completion(error) }
            if let error = error {
                Logger.error("Create user error: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
                return
            }
        }
    }
    
    func signInUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            defer { completion(error) }
            if let error = error {
                Logger.error("Login user error: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
                return
            }
        }
    }
    
    func setUserDisplayName(to displayName: String, completion: @escaping (Error?) -> Void) {
        guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { completion(nil); return }
        changeRequest.displayName = displayName
        changeRequest.commitChanges { (error) in
            defer { completion(error) }
            if let error = error {
                Logger.error("Update display name error: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
                return
            }
        }
    }
}
