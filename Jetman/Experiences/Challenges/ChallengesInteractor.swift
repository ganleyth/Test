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
    }
}

// MARK: - private
private extension ChallengesInteractor {
    
    func initiateFriendsFetch() {
        
    }
}


// MARK: - Table view data source
extension ChallengesInteractor: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
