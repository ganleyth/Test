//
//  LeaderboardInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 7/1/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class LeaderboardInteractor: Interactor {
    
}

extension LeaderboardInteractor: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(UINib(nibName: "RightDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailTableViewCell", for: indexPath) as? RightDetailTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
