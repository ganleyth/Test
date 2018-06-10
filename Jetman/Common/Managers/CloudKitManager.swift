//
//  CloudKitManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/10/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import CloudKit

enum RecordType: String {
    case user = "User"
}

class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    func fetchUser(with completion: @escaping (_ user: User?) -> Void) {
        CKContainer.default().fetchUserRecordID { [weak self] (recordID, error) in
            var returnUser: User? = nil
            let returningCompletion = { DispatchQueue.main.async { completion(returnUser) } }
            guard let this = self else { returningCompletion(); return }
            
            if let error = error {
                DispatchQueue.main.async {
                    AppDelegate.shared.topViewController?.presentInfoAlertWith(title: "Unable to log in user", message: error.localizedDescription)
                }
                Logger.error("Error fetching user ID: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            guard let recordID = recordID else { returningCompletion(); return }
            let predicate = NSPredicate(format: "iCloudRecordID == %@", recordID)
            this.fetchRecordsThatMatch(CKContainer.default().publicCloudDatabase, recordType: .user, predicate: predicate, with: { (records) in
                guard
                    let firstRecord = records?.first,
                    let user = User(record: firstRecord) else { returningCompletion(); return }
                
                returnUser = user
                returningCompletion()
            })
        }
    }
}

private extension CloudKitManager {
    
    func fetchRecordsThatMatch(_ database: CKDatabase, recordType: RecordType, predicate: NSPredicate, with completion: @escaping (_ records: [CKRecord]?) -> Void) {
        let query = CKQuery(recordType: recordType.rawValue, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                DispatchQueue.main.async {
                    AppDelegate.shared.topViewController?.presentInfoAlertWith(title: "Unable to log in user", message: error.localizedDescription)
                }
                Logger.error("Error fetching user record: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
}
