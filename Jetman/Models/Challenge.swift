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
    var opponentID: String? = nil
    let selfInitiated: Bool
    var score: Int? = nil
    
    init(opponentID: String) {
        id = UUID().uuidString
        self.opponentID = opponentID
        selfInitiated = true
    }
    
    init(id: String, opponentID: String?, selfInitiated: Bool, score: Int? = nil) {
        self.id = id
        self.opponentID = opponentID
        self.selfInitiated = selfInitiated
        self.score = score
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case opponentID = "opponent_id"
        case selfInitiated = "self_initiated"
        case score
    }
}

// MARK: - Computed properties
extension Challenge {
    var dictionaryRepresentation: [String: Any] {
        var d: [String: Any] = [:]
        
        d[Constants.Challenges.opponentID] = opponentID
        d[Constants.Challenges.selfInitiated] = selfInitiated
        d[Constants.Challenges.score] = score
        
        return d
    }
}
