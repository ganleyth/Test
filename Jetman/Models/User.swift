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
}

// CloudKit
extension User: CloudKitSyncable {
    init?(record: CKRecord) {
        guard let iCloudRecordID = record.value(forKey: Constants.CloudKit.User.iCloudRecordID) as? CKRecordID else { return nil }
        
        self.iCloudRecordID = iCloudRecordID
    }
}
