//
//  NewChallengeInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class NewChallengeInteractor: Interactor {}

extension NewChallengeInteractor: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseManager.shared.friendManager.contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        guard let contact = FirebaseManager.shared.friendManager.contacts?[indexPath.row] else { return cell }
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        return cell
    }
}
