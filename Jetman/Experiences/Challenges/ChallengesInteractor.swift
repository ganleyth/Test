//
//  ChallengesInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/17/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class ChallengesInteractor: Interactor {
    var challengesViewController: ChallengesViewController? {
        return viewController as? ChallengesViewController
    }
    
    override init() {
        super.init()
        challengesViewController?.tableView.dataSource = self
        challengesViewController?.loadViewIfNeeded()
        initiateFriendsFetch()
    }
}

// MARK: - private
private extension ChallengesInteractor {
    
    func initiateFriendsFetch() {
        GameCenterManager.shared.fetchFriends { [weak self] in
            guard let this = self else { return }
            this.refreshUI()
        }
    }
    
    func refreshUI() {
        challengesViewController?.tableView.reloadData()
    }
}


// MARK: - Table view data source
extension ChallengesInteractor: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameCenterManager.shared.friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let friend = GameCenterManager.shared.friends?[indexPath.row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        cell.textLabel?.text = friend.displayName
        
        return cell
    }
}
