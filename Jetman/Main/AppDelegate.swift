//
//  AppDelegate.swift
//  Jetman
//
//  Created by Thomas Ganley on 11/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import Firebase
import Branch
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared = AppDelegate()

    var window: UIWindow?
    var gameCenterVC: UIViewController? {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.gameCenterVCReceived, object: self)
        }
    }
    
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
            assertionFailure("Unhandled topVC case")
            return nil
        }
        
        while let vc = topVC.presentedViewController {
            topVC = vc
        }
        
        return topVC
    }
    
    var viewControllerToPresent: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Branch session
        let branch = Branch.getInstance()
        branch?.setDebug()
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { (params, error) in
            if let error = error {
                assertionFailure("Error initializing Branch: \(error.localizedDescription)")
            }
        })
        
        // Load sprites into memory on launch
        SpriteLoader.shared.loadSprites(for: GameSession.shared.settings.playerGender)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
            }
            if let error = error {
                Logger.error("Error authorizing remote notification options: \(error.localizedDescription)", filePath: #file, funcName: #function, lineNumber: #line)
            }
        }
        
        // Messaging delegate
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().remoteMessageDelegate = self
        
        FirebaseApp.configure()
        
        return true
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        handleDeepLink(for: url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Branch.getInstance().handlePushNotification(userInfo)
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
    
    func handleDeepLink(for url: URL) {
        guard
            let params = url.getURLParameters(),
            let challengeID = params[Constants.Challenges.challengeID],
            let senderID = params[Constants.Challenges.senderID] else { return }
        
        let challenge = Challenge(id: challengeID, opponentID: senderID, selfInitiated: false)
        presentChallengeVCFor(challenge: challenge)
        NotificationCenter.default.post(name: Constants.Notifications.challengeReceived, object: self)
    }
    
    func presentChallengeVCFor(challenge: Challenge) {
        guard let challengeResponseVC = UIStoryboard(name: "ChallengeResponseView", bundle: nil).instantiateInitialViewController() as? ChallengeResponseViewController else { return }
        
        challengeResponseVC.challenge = challenge
        AppDelegate.shared.viewControllerToPresent = challengeResponseVC
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {}
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {}
}
