//
//  User.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/10/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import CloudKit

struct User {
    let iCloudRecordID: CKRecordID
    let username: String?
    let highScore: Int
    
    var recordID: CKRecordID?
}

// CloudKit
extension User: CloudKitSyncable {
    init?(record: CKRecord) {
        guard
            let iCloudRecordReference = record.value(forKey: Constants.CloudKit.User.iCloudRecordReference) as? CKReference,
            let highScore = record.value(forKey: Constants.CloudKit.User.highScore) as? Int else { return nil }
        
        let username = record.value(forKey: Constants.CloudKit.User.username) as? String
        
        self.iCloudRecordID = iCloudRecordReference.recordID
        self.username = username
        self.highScore = highScore
        
        self.recordID = record.recordID
    }
}
