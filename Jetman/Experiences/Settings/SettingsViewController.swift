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
    
    fileprivate var soundsIsOn: Bool! {
        didSet {
            soundsSwitch.setImage((soundsIsOn ? #imageLiteral(resourceName: "SwitchOn") : #imageLiteral(resourceName: "SwitchOff")), for: .normal)
            GameSession.shared.settings.allowSounds = soundsIsOn
        }
    }
    
    fileprivate var hapticsIsOn: Bool! {
        didSet {
            hapticsSwitch.setImage((hapticsIsOn ? #imageLiteral(resourceName: "SwitchOn") : #imageLiteral(resourceName: "SwitchOff")), for: .normal)
            GameSession.shared.settings.allowHaptics = hapticsIsOn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundsIsOn = GameSession.shared.settings.allowSounds
        hapticsIsOn = GameSession.shared.settings.allowHaptics
    }
    
    weak var delegate: WelcomeViewEmbeddedControllerDelegate?
    
    @IBAction func toggleSounds(_ sender: UIButton) {
        soundsIsOn = !soundsIsOn
    }
    
    @IBAction func toggleHaptics(_ sender: UIButton) {
        hapticsIsOn = !hapticsIsOn
    }
    
    @IBAction func dismissSettingsView(_ sender: UIButton) {
        delegate?.embeddedControllerShouldDismiss()
    }
}
