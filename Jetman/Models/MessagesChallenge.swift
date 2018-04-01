//
//  MessagesChallenge.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/1/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation
import Messages

class MessagesChallenge: MSMessage {
    override init() {
        super.init()
        let template = MSMessageTemplateLayout()
        template.image = #imageLiteral(resourceName: "LaunchScreen")
        template.caption = "I challenge you to a ProjectYelnag match!"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
