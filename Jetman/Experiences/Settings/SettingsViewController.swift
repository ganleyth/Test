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
    @IBOutlet weak var genderSelectionSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableSoundsSwitch.setOn(GameSession.shared.settings.allowSounds, animated: false)
        enableHapticsSwitch.setOn(GameSession.shared.settings.allowHaptics, animated: false)
        genderSelectionSegmentedControl.selectedSegmentIndex = GameSession.shared.settings.playerGender == .boy ? 0 : 1
    }
    
    @IBAction func updateSoundsSetting(_ sender: UISwitch) {
        GameSession.shared.settings.allowSounds = sender.isOn
    }
    
    @IBAction func updateHapticsSetting(_ sender: UISwitch) {
        GameSession.shared.settings.allowHaptics = sender.isOn
    }
    
    @IBAction func updatePlayerSelectionSetting(_ sender: UISegmentedControl) {
        GameSession.shared.settings.playerGender = sender.selectedSegmentIndex == 0 ? .boy : .girl
    }
    
    @IBAction func dismissSettingsView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
