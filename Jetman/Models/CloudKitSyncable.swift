//
//  CloudKitSyncable.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/10/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import CloudKit

protocol CloudKitSyncable {
    init?(record: CKRecord)
}
