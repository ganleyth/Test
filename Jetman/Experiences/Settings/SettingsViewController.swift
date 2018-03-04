//
//  SettingsViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/3/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var enableSoundsSwitch: UISwitch!
    @IBOutlet weak var enableHapticsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableSoundsSwitch.setOn(GameSession.shared.settings.allowSounds, animated: false)
        enableHapticsSwitch.setOn(GameSession.shared.settings.allowHaptics, animated: false)
    }
    
    @IBAction func updateSoundsSetting(_ sender: UISwitch) {
        GameSession.shared.settings.allowSounds = sender.isOn
    }
    
    @IBAction func updateHapticsSetting(_ sender: UISwitch) {
        GameSession.shared.settings.allowHaptics = sender.isOn
    }

    @IBAction func dismissSettingsView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
