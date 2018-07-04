//
//  AppDelegate.swift
//  Jetman
//
//  Created by Thomas Ganley on 11/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared = AppDelegate()

    var window: UIWindow?
    var gameCenterVC: UIViewController?
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    var topViewController: UIViewController? {
        var topVC: UIViewController
        if let navController = keyWindow?.rootViewController as? UINavigationController,
            let vc = navController.topViewController {
            topVC = vc
        } else if let vc = keyWindow?.rootViewController {
            topVC = vc
        } else {
            return nil
        }
        
        while let vc = topVC.presentedViewController {
            topVC = vc
        }
        
        return topVC
    }
    
    var viewControllerToPresent: UIViewController?
    private lazy var serialQueue = DispatchQueue(label: "ActivityIndicatorSerialQueue")
    var _activityIndicatorView: ActivityIndicatorView?
    var activityIndicatorView: ActivityIndicatorView? {
        get {
            var result: ActivityIndicatorView?
            serialQueue.sync {
                result = _activityIndicatorView
            }
            return result
        }
        set {
            serialQueue.sync {
                _activityIndicatorView = newValue
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Load sprites into memory on launch
        SpriteLoader.shared.loadSprites(for: GameSession.shared.settings.playerGender)
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, .badge, .sound]) { (granted, error) in
//            if granted {
//                DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
//            }
//            if let error = error {
//                Logger.error("Error authorizing remote notification options: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
//            }
//        }
        
        // Messaging delegate
        UNUserNotificationCenter.current().delegate = self
//        Messaging.messaging().remoteMessageDelegate = self
        
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3667026795210788~2234868642")
        
        // User authentication
        CloudKitManager.shared.fetchUser { [weak self] (iCloudRecordID, user) in
            guard let this = self else { return }
            if user == nil {
                guard let iCloudRecordID = iCloudRecordID else {
                    this.topViewController?.presentInfoAlertWith(title: Constants.Notifications.UserInfo.iCloudLoginTitle,
                                                                 message: Constants.Notifications.UserInfo.iCloudLoginMessage)
                    return
                }
                CloudKitManager.shared.createUserWith(iCloudRecordID: iCloudRecordID, completion: { (createdUser) in
                    guard let createdUser = createdUser else {
                        Logger.error("New user not created", filePath: #file, funcName: #function, lineNumber: #line)
                        return
                    }
                    GameSession.shared.currentUser = createdUser
                    if createdUser.username == nil {
                        NotificationCenter.default.post(name: Constants.Notifications.requestNewUsernameEntry, object: self)
                    }
                })
                return
            }
            
            if user?.username == nil {
                NotificationCenter.default.post(name: Constants.Notifications.requestNewUsernameEntry, object: self)
            }
        }
        
        return true
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
}

// Activity Indicator
extension AppDelegate {
    func showActivityIndicator() {
        guard
            activityIndicatorView == nil,
            let activityIndicatorView = UINib(nibName: "ActivityIndicator", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ActivityIndicatorView,
            let topVC = topViewController else { return }
        
        activityIndicatorView.alpha = 0
        topVC.animateCenterPresentation(of: activityIndicatorView, shouldShow: true, completion: nil)
        self.activityIndicatorView = activityIndicatorView
    }
    
    func hideActivityIndicator() {
        guard let activityIndicatorView = activityIndicatorView else { return }
        activityIndicatorView.endActivityAnimation { [weak self] in
            guard let this = self else { return }
            activityIndicatorView.removeFromSuperview()
            this.activityIndicatorView = nil
        }
    }
}

private extension AppDelegate {
    
    func autheticateLocalPlayer() {
        GameCenterManager.shared.authenticateLocalPlayer { [weak self] (gameCenterVC, error) in
            guard let this = self else { return }
            if let gameCenterVC = gameCenterVC {
                this.gameCenterVC = gameCenterVC
            }
            
            if let error = error {
                Logger.error("Error authenticating local player: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
        }
    }
    
    func presentChallengeVCFor(challenge: Challenge) {
        guard let challengeResponseVC = UIStoryboard(name: "ChallengeResponseView", bundle: nil).instantiateInitialViewController() as? ChallengeResponseViewController else { return }
        
        challengeResponseVC.challenge = challenge
        AppDelegate.shared.viewControllerToPresent = challengeResponseVC
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {}
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {}
//}
