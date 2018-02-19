//
//  CustomSubclasses.swift
//  Jetman
//
//  Created by Thomas Ganley on 2/18/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class CustomUIImpactFeedbackGenerator: UIImpactFeedbackGenerator {
    override func impactOccurred() {
        if GameSession.shared.settings.allowHaptics {
            super.impactOccurred()
        }
    }
}
