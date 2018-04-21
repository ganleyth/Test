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
    
    init(senderID: String) {
        super.init()

        let challengeID = UUID().uuidString
//        let url = URL(string: "https://jetpackjimmyy04i.app.link/iGHwFeuP8L")?.appending(challengeID: challengeID, senderID: senderID)
        let url = URL(string: "https://jetpackjimmyy04i.app.link/iGHwFeuP8L")
        self.url = url
        
        let template = MSMessageTemplateLayout()
        template.image = #imageLiteral(resourceName: "LaunchScreen")
        template.caption = "I challenge you to a ProjectYelnag match!"
        self.layout = template
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension URL {
    func appending(challengeID: String, senderID: String) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let queryItems = [
            URLQueryItem(name: Constants.Challenges.challengeID, value: challengeID),
            URLQueryItem(name: Constants.Challenges.senderID, value: senderID)
        ]
        components?.queryItems = queryItems
        
        return components?.url ?? self
    }
}
