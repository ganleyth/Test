//
//  Manager.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/21/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Manager {
    
    var database: Database {
        return Database.database()
    }
    
    var defaultDatabaseReference: DatabaseReference {
        return database.reference()
    }
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
}
