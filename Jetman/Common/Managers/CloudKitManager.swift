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
    
    func fetchUser(with completion: @escaping (_ iCloudRecordID: CKRecordID?, _ user: User?) -> Void) {
        CKContainer.default().fetchUserRecordID { [weak self] (recordID, error) in
            var returniCloudRecordID: CKRecordID? = nil
            var returnUser: User? = nil
            let returningCompletion = { completion(returniCloudRecordID, returnUser) }
            guard let this = self else { returningCompletion(); return }
            
            if let error = error {
                AppDelegate.shared.topViewController?.presentInfoAlertWith(title: "Unable to log in user",
                                                                           message: "Check your network connection and try again")
                Logger.error("Error fetching user ID: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            guard let recordID = recordID else { returningCompletion(); return }
            returniCloudRecordID = recordID
            let predicate = NSPredicate(format: "iCloudRecordReference == %@", CKReference(recordID: recordID, action: .deleteSelf))
            this.fetchRecordsThatMatch(CKContainer.default().publicCloudDatabase, recordType: .user, predicate: predicate, with: { (records, error) in
                if let error = error {
                    AppDelegate.shared.topViewController?.presentInfoAlertWith(title: "Unable to log in user",
                                                                               message: "Check your network connection and try again")
                }
                
                guard
                    let firstRecord = records?.first,
                    let user = User(record: firstRecord) else { returningCompletion(); return }
                
                returnUser = user
                returningCompletion()
            })
        }
    }
    
    func createUserWith(iCloudRecordID: CKRecordID, completion: @escaping (_ user: User?) -> Void) {
        let record = CKRecord(useriCloudRecordID: iCloudRecordID)
        
        save(record: record, to: CKContainer.default().publicCloudDatabase) { (record, error) in
            var returnUser: User? = nil
            let returnCompletion = { completion(returnUser) }
            if let error = error {
                Logger.error("Error saving new user: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            guard
                let record = record,
                let user = User(record: record) else {
                    Logger.error("Could not save new user", filePath: #file, funcName: #function, lineNumber: #line)
                    AppDelegate.shared.topViewController?.presentInfoAlertWith(title: "Could not create new user", message: "Check your network connection and try again")
                    returnCompletion()
                    return
            }
            
            returnUser = user
            returnCompletion()
        }
    }
}

private extension CloudKitManager {
    
    func fetchRecordsThatMatch(_ database: CKDatabase, recordType: RecordType, predicate: NSPredicate, with completion: @escaping (_ records: [CKRecord]?, _ error: Error?) -> Void) {
        let query = CKQuery(recordType: recordType.rawValue, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                Logger.error("Error fetching user record: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                completion(records, error)
            }
        }
    }
    
    func save(record: CKRecord, to database: CKDatabase, with completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        database.save(record) { (record, error) in
            if let error = error {
                Logger.error("Error saving record: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                completion(record, error)
            }
        }
    }
}
