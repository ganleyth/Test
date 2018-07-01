//
//  CKRecord+AppExtensions.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/10/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import CloudKit

extension CKRecord {
    
    convenience init(useriCloudRecordID: CKRecordID) {
        self.init(recordType: Constants.CloudKit.User.recordName)
        setValue(CKReference(recordID: useriCloudRecordID, action: .deleteSelf), forKey: Constants.CloudKit.User.iCloudRecordReference)
        setValue(UserDefaults.standard.value(forKey: Constants.UserDefaults.highScore) ?? 0, forKey: Constants.CloudKit.User.highScore)
    }
}
