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
                Logger.error("Error fetching user ID: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            guard let recordID = recordID else { returningCompletion(); return }
            returniCloudRecordID = recordID
            let predicate = NSPredicate(format: "iCloudRecordReference == %@", CKReference(recordID: recordID, action: .deleteSelf))
            this.fetchRecordsThatMatch(CKContainer.default().publicCloudDatabase, recordType: .user, predicate: predicate, with: { (records, error) in
                if let error = error {
                    Logger.error("Error fetching user: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
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
                    returnCompletion()
                    return
            }
            
            returnUser = user
            returnCompletion()
        }
    }
    
    func checkIsUsernameAvailable(username: String, with completion: @escaping (_ isAvailable: Bool, _ error: Error?) -> Void) {
        let predicate = NSPredicate(format: "\(Constants.CloudKit.User.username) == %@", username)
        let query = CKQuery(recordType: Constants.CloudKit.User.recordName, predicate: predicate)
        perform(query: query, in: CKContainer.default().publicCloudDatabase) { (records, error) in
            var isAvailable = false
            if let records = records, records.isEmpty {
                isAvailable = true
            }
            
            completion(isAvailable, error)
        }
    }
    
    func setUsername(_ username: String, with completion: @escaping (_ success: Bool) -> Void) {
        guard let recordID = GameSession.shared.currentUser?.recordID else { completion(false); return }
        let newKeysAndValues: [String: Any] = [Constants.CloudKit.User.username: username]
        update(recordID: recordID, in: CKContainer.default().publicCloudDatabase, withNewKeysAndValues: newKeysAndValues) { (success, record) in
            if success,
                let record = record,
                let user = User(record: record) {
                GameSession.shared.currentUser = user
            }
            completion(success)
        }
    }
}

private extension CloudKitManager {
    
    func fetchRecordsThatMatch(_ database: CKDatabase, recordType: RecordType, predicate: NSPredicate, with completion: @escaping (_ records: [CKRecord]?, _ error: Error?) -> Void) {
        let query = CKQuery(recordType: recordType.rawValue, predicate: predicate)
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                Logger.error("Error fetching user record: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                AppDelegate.shared.hideActivityIndicator()
                completion(records, error)
            }
        }
    }
    
    func save(record: CKRecord, to database: CKDatabase, with completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        database.save(record) { (record, error) in
            if let error = error {
                Logger.error("Error saving record: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                AppDelegate.shared.hideActivityIndicator()
                completion(record, error)
            }
        }
    }
    
    func perform(query: CKQuery, in database: CKDatabase, with completion: @escaping (_ records: [CKRecord]?, _ error: Error?) -> Void) {
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                Logger.error("Error performing query: \(query): \n\(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                AppDelegate.shared.hideActivityIndicator()
                completion(records, error)
            }
        }
    }
    
    func update(recordID: CKRecordID, in database: CKDatabase, withNewKeysAndValues newKeysAndValues: [String: Any], with completion: @escaping (_ success: Bool, _ record: CKRecord?) -> Void) {
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        fetchRecordWith(recordID: recordID, in: database) { [weak self] (record, error) in
            guard let this = self else { completion(false, nil); return }
            
            DispatchQueue.main.async { AppDelegate.shared.hideActivityIndicator() }
            
            if let error = error {
                Logger.error("Could not fetch record \(recordID) to update it: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
                completion(false, nil)
                return
            }
            
            guard let record = record else {
                Logger.info("Record to update was not found: record \(recordID)", filePath: #file, funcName: #function, lineNumber: #line)
                completion(false, nil)
                return
            }
            
            newKeysAndValues.forEach({ (key, value) in
                record.setValue(value, forKey: key)
            })
            
            DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
            this.save(record: record, to: database, with: { (record, error) in
                var success = true
                newKeysAndValues.keys.forEach {
                    if record?.value(forKey: $0) == nil {
                        success = false
                    }
                }
                DispatchQueue.main.async {
                    AppDelegate.shared.hideActivityIndicator()
                    completion(success, record)
                }
            })
        }
    }
    
    func fetchRecordWith(recordID: CKRecordID, in database: CKDatabase, completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        database.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                Logger.error("Error fetching record with id \(recordID): \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                AppDelegate.shared.hideActivityIndicator()
                completion(record, error)
            }
        }
    }
}
