//
//  AppDelegate.swift
//  Jetman
//
//  Created by Thomas Ganley on 11/23/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gameCenterVC: UIViewController? {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.gameCenterVCReceived, object: self)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        autheticateLocalPlayer()

        // Load sprites into memory on launch
        SpriteLoader.shared.loadSprites(for: GameSession.shared.settings.playerGender)
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

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

