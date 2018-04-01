//
//  Challenge.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation

struct Challenge: Codable {
    let id: String
    let opponentID: String
    let selfInitiated: Bool
    var score: Int? = nil
    
    init(opponentID: String) {
        id = UUID().uuidString
        self.opponentID = opponentID
        selfInitiated = true
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case opponentID = "opponent_id"
        case selfInitiated = "self_initiated"
        case score
    }
}
