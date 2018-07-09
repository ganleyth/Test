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
    
    enum OperationCategory: String {
        case leaderboardFetch
    }
    
    static let shared = CloudKitManager()
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .default
        return queue
    }()

    func fetchUser(with completion: @escaping (_ iCloudRecordID: CKRecordID?, _ user: User?) -> Void) {
        CKContainer.default().fetchUserRecordID { [weak self] (recordID, error) in
            var returniCloudRecordID: CKRecordID? = nil
            var returnUser: User? = nil
            let returningCompletion = { DispatchQueue.main.async { completion(returniCloudRecordID, returnUser) } } 
            guard let this = self else { returningCompletion(); return }
            
            if let error = error {
                Logger.error("Error fetching user ID: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            guard let recordID = recordID else { returningCompletion(); return }
            returniCloudRecordID = recordID
            let predicate = NSPredicate(format: "iCloudRecordReference == %@", CKReference(recordID: recordID, action: .deleteSelf))
            this.fetchRecordsThatMatch(CKContainer.default().publicCloudDatabase, recordType: .user, predicate: predicate, qualityOfService: .userInteractive, with: { (records) in
                guard
                    let firstRecord = records?.first,
                    let user = User(record: firstRecord) else { returningCompletion(); return }
                
                GameSession.shared.currentUser = user
                returnUser = user
                
                // Make sure the local high score is up to date with the remote high score
                if user.highScore > (GameSession.shared.highScore ?? 0) {
                    GameSession.shared.highScore = user.highScore
                } else if let localHighScore = GameSession.shared.highScore, localHighScore > user.highScore {
                    this.updateHighScore(localHighScore, completion: nil)
                }
                
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
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        update(recordID: recordID, in: CKContainer.default().publicCloudDatabase, withNewKeysAndValues: newKeysAndValues) { (success, record) in
            DispatchQueue.main.async { AppDelegate.shared.hideActivityIndicator() }
            if success,
                let record = record,
                let user = User(record: record) {
                GameSession.shared.currentUser = user
            }
            completion(success)
        }
    }
    
    func updateHighScore(_ score: Int, completion: ((_ success: Bool) -> Void)?) {
        guard let userRecordID = GameSession.shared.currentUser?.recordID else { return }
        
        let newKeysAndValues = [Constants.CloudKit.User.highScore: score]
        
        update(recordID: userRecordID, in: CKContainer.default().publicCloudDatabase, withNewKeysAndValues: newKeysAndValues) { (success, record) in
            if success,
                let record = record,
                let user = User(record: record) {
                GameSession.shared.currentUser = user
            }
            completion?(success)
        }
    }
    
    func fetchLeaders(completion: @escaping (_ leaders: [User]) -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptors = [NSSortDescriptor(key: Constants.CloudKit.User.highScore, ascending: false)]
        DispatchQueue.main.async { AppDelegate.shared.showActivityIndicator() }
        fetchRecordsThatMatch(CKContainer.default().publicCloudDatabase, recordType: .user, predicate: predicate, sortDescriptors: sortDescriptors, resultsLimit: 10, qualityOfService: .userInitiated) { (records) in
            DispatchQueue.main.async { AppDelegate.shared.hideActivityIndicator() }
            var leaders = [User]()
            defer { completion(leaders) }
            
            guard let records = records else { return }
            leaders = records.compactMap { User(record: $0) }
        }
    }
    
    func cancelOperation(for category: OperationCategory) {
        operationQueue.operations.filter({ $0.name == category.rawValue }).forEach { $0.cancel() }
        switch category {
        case .leaderboardFetch:
            AppDelegate.shared.hideActivityIndicator()
        }
    }
}

private extension CloudKitManager {
    
    func fetchRecordsThatMatch(_ database: CKDatabase, recordType: RecordType, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]? = nil, resultsLimit: Int? = nil, qualityOfService: QualityOfService = .background, category: OperationCategory? = nil, with completion: @escaping (_ records: [CKRecord]?) -> Void) {
        
        let query = CKQuery(recordType: recordType.rawValue, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        let operation = CKQueryOperation(query: query)
        if let rl = resultsLimit { operation.resultsLimit = rl }
        
        var records = [CKRecord]()
        operation.recordFetchedBlock = { (record) in
            records.append(record)
        }
        
        operation.queryCompletionBlock = { (_, _) in
            DispatchQueue.main.async {
                completion(records)
            }
        }
        
        operation.database = database
        operation.qualityOfService = qualityOfService
        operation.name = category?.rawValue
        
        operationQueue.addOperation(operation)
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
    
    func perform(query: CKQuery, in database: CKDatabase, with completion: @escaping (_ records: [CKRecord]?, _ error: Error?) -> Void) {
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                Logger.error("Error performing query: \(query): \n\(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                completion(records, error)
            }
        }
    }
    
    func update(recordID: CKRecordID, in database: CKDatabase, withNewKeysAndValues newKeysAndValues: [String: Any], with completion: @escaping (_ success: Bool, _ record: CKRecord?) -> Void) {
        fetchRecordWith(recordID: recordID, in: database) { [weak self] (record, error) in
            guard let this = self else { completion(false, nil); return }
            
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
            
            this.save(record: record, to: database, with: { (record, error) in
                var success = true
                newKeysAndValues.keys.forEach {
                    if record?.value(forKey: $0) == nil {
                        success = false
                    }
                }
                DispatchQueue.main.async {
                    completion(success, record)
                }
            })
        }
    }
    
    func fetchRecordWith(recordID: CKRecordID, in database: CKDatabase, completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        database.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                Logger.error("Error fetching record with id \(recordID): \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
            
            DispatchQueue.main.async {
                completion(record, error)
            }
        }
    }
}
