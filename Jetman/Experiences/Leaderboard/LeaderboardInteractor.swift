//
//  LeaderboardInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 7/1/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class LeaderboardInteractor: Interactor {
    var leaders: [User] = []
    var uiRefresh: (() -> Void)?
    
    func fetchLeaders() {
        CloudKitManager.shared.fetchLeaders { [weak self] (leaders) in
            guard let this = self else { return }
            this.leaders = leaders
            this.uiRefresh?()
        }
    }
}

extension LeaderboardInteractor: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(UINib(nibName: "RightDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        return leaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as? RightDetailTableViewCell else { return UITableViewCell() }
        
        let leader = leaders[indexPath.row]
        cell.configureWith(primaryText: leader.username ?? "Unnamed User", secondaryText: "\(leader.highScore)")
        
        return cell
    }
}
