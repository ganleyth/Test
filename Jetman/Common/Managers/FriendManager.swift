//
//  FriendManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import Contacts
import FirebaseDatabase

class FriendManager: Manager {
    
    func verifyFriendStatus(forSender senderID: String, with completion: @escaping (_ isFriend: Bool) -> Void) {
        guard let currentUser = currentUser else { completion(false); return }
        let childReference = defaultDatabaseReference.child("\(currentUser.uid)/friends/\(senderID)")
        childReference.observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func addFriend(_ friend: Friend) {
        guard let currentUser = currentUser else { return }
        let childReference = defaultDatabaseReference.child("\(currentUser.uid)/friends/\(friend.id)")
        childReference.setValue(friend.dictionaryRepresentation)
    }
}
