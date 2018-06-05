//
//  SettingsViewController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/3/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet fileprivate var soundsSwitch: UIButton!
    @IBOutlet fileprivate var hapticsSwitch: UIButton!
    
    fileprivate var soundsIsOn = false
    fileprivate var hapticsIsOn = false
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleSounds(_ sender: UIButton) {
        soundsIsOn = !soundsIsOn
        soundsSwitch.setImage((soundsIsOn ? #imageLiteral(resourceName: "SwitchOn") : #imageLiteral(resourceName: "SwitchOff")), for: .normal)
        GameSession.shared.settings.allowSounds = soundsIsOn
    }
    
    @IBAction func toggleHaptics(_ sender: UIButton) {
        hapticsIsOn = !hapticsIsOn
        hapticsSwitch.setImage((hapticsIsOn ? #imageLiteral(resourceName: "SwitchOn") : #imageLiteral(resourceName: "SwitchOff")), for: .normal)
        GameSession.shared.settings.allowHaptics = hapticsIsOn
    }
    
    @IBAction func dismissSettingsView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
