//
//  LoginManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginManager {
    
    static let shared = LoginManager()
    
    var user: User?
    
    func signupUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            defer { completion(error) }
            if let error = error {
                Logger.error("Create user error: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
                return
            }
            
            guard let user = user else {
                Logger.info("Returned new user object is nil", filePath: #file, funcName: #function, lineNumber: #line)
                return
            }
            
            self.user = user
        }
    }
    
}
