//
//  MyChallengesInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class MyChallengesInteractor: Interactor {}

extension MyChallengesInteractor: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MyChallengesInteractor: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Respond to challenge
    }
}
