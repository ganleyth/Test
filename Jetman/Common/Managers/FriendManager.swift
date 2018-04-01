//
//  FriendManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit
import Contacts

class FriendManager {
    
    private(set) var contacts: [CNContact]?
    
    func fetchContacts(with completion: @escaping (Error?) -> Void) {
        guard contacts == nil else { completion(nil); return }
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] (granted, error) in
            var returnError = error
            defer { DispatchQueue.main.async { completion(returnError) } }
            guard let this = self else { return }
            if let error = error {
                assertionFailure("Could not complete access authorization for user's contacts: \(error.localizedDescription)")
                return
            }
            
            if granted {
                do {
                    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
                    let unsortedContacts = try store.unifiedContacts(matching: predicate, keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
                    let sortedContacts = unsortedContacts.sorted { "\($0.givenName) \($0.familyName)" < "\($1.givenName) \($1.familyName)" }
                    this.contacts = sortedContacts.filter { (contact) -> Bool in
                        guard let firstCharacter = contact.givenName.first else { return false }
                        let alphabet = CharacterSet.letters
                        let firstCharacterSet = CharacterSet(charactersIn: String(firstCharacter))
                        return firstCharacterSet.isSubset(of: alphabet)
                    }
                } catch {
                    returnError = error
                }
            } else {
                UIApplication.shared.keyWindow?.rootViewController?.presentInfoAlertWith(title: "Cannot access contacts",
                                                                                         message: "Please authorize access to your contacts in the Settings app so that you can challenge your friends")
            }
        }
    }
}
