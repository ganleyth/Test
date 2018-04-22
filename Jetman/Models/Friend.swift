//
//  Friend.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/22/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation

struct Friend: Codable {
    let id: String
    let recordAgainst: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case recordAgainst = "record_against"
    }
}

// Computed properties
extension Friend {
    var dictionaryRepresentation: [String: Any] {
        var d: [String: Any] = [:]
        d[Constants.Friend.recordAgainst] = recordAgainst
        return d
    }
}
