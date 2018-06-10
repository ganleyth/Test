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
    
    func fetchUser(with completion: @escaping (_ recordID: CKRecordID?) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                DispatchQueue.main.async {
                    AppDelegate.shared.topViewController?.presentInfoAlertWith(title: "Unable to log in user", message: error.localizedDescription)
                }
                Logger.error("Error fetching user ID: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                completion(recordID)
            }
        }
    }
}
