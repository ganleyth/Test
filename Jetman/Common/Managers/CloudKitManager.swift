//
//  CloudKitManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/10/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import CloudKit

class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    func requestiCloudAccountStatus(with completion: @escaping (_ isActive: Bool) -> Void) {
        CKContainer.default().accountStatus { (status, error) in
            DispatchQueue.main.async {
                completion(status == CKAccountStatus.available)
            }
        }
    }
}
