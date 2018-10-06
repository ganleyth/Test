//
//  FireModeManager.swift
//  Jetman
//
//  Created by Thomas Ganley on 10/6/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation

class FireModeManager {
    private var timer: Timer?
    var inFireMode = false
    
    func enterFireMode() {
        inFireMode = true
        timer = Timer(fire: Date(timeInterval: 10, since: Date()), interval: 0, repeats: false) { [weak self] (_) in
            guard let this = self else { return }
            NotificationCenter.default.post(name: Constants.Notifications.fireModeEnd, object: self)
            this.timer = nil
            this.inFireMode = false
        }
    }
}
