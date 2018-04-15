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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gameCenterVC: UIViewController? {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.gameCenterVCReceived, object: self)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Load sprites into memory on launch
        SpriteLoader.shared.loadSprites(for: GameSession.shared.settings.playerGender)
        FirebaseApp.configure()
        
        let branch = Branch.getInstance()
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { (params, error) in
            if let error = error {
                assertionFailure("Error initializing Branch: \(error.localizedDescription)")
            }
        })
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Branch.getInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }
}

extension AppDelegate {
    
    func reset() {
        guard let newGameplayVC = UIStoryboard(name: "GameplayView", bundle: nil).instantiateInitialViewController() else { return }
        UIApplication.shared.keyWindow?.rootViewController = newGameplayVC
    }
    
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
}

