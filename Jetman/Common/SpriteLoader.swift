//
//  SpriteLoader.swift
//  Jetman
//
//  Created by Thomas Ganley on 1/20/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import SpriteKit

class SpriteLoader {
    static let shared = SpriteLoader()
    var texturesForGenderAndState: [Player.State: [SKTexture]] = [:]
    
    var hasLoadedForBoy = false
    var hasLoadedForGirl = false

    func loadSprites(for gender: Player.Gender) {
        if gender == .boy {
            texturesForGenderAndState[.idle] = [#imageLiteral(resourceName: "JetmanIdle0"), #imageLiteral(resourceName: "JetmanIdle1"), #imageLiteral(resourceName: "JetmanIdle2"), #imageLiteral(resourceName: "JetmanIdle3"), #imageLiteral(resourceName: "JetmanIdle4"), #imageLiteral(resourceName: "JetmanIdle5"), #imageLiteral(resourceName: "JetmanIdle6"), #imageLiteral(resourceName: "JetmanIdle7"), #imageLiteral(resourceName: "JetmanIdle8"), #imageLiteral(resourceName: "JetmanIdle9")].map { SKTexture(image: $0) }
            texturesForGenderAndState[.flying] = [#imageLiteral(resourceName: "JetmanFlying0"), #imageLiteral(resourceName: "JetmanFlying1"), #imageLiteral(resourceName: "JetmanFlying2"), #imageLiteral(resourceName: "JetmanFlying3"), #imageLiteral(resourceName: "JetmanFlying4"), #imageLiteral(resourceName: "JetmanFlying5"), #imageLiteral(resourceName: "JetmanFlying6"), #imageLiteral(resourceName: "JetmanFlying7"), #imageLiteral(resourceName: "JetmanFlying8"), #imageLiteral(resourceName: "JetmanFlying9")].map { SKTexture(image: $0) }
            texturesForGenderAndState[.dead] = [#imageLiteral(resourceName: "JetmanDead0")].map { SKTexture(image: $0) }
            texturesForGenderAndState[.levelComplete] = texturesForGenderAndState[.flying]
            hasLoadedForBoy = true
        } else {
            texturesForGenderAndState[.idle] = [#imageLiteral(resourceName: "JetmanIdle0"), #imageLiteral(resourceName: "JetmanIdle1"), #imageLiteral(resourceName: "JetmanIdle2"), #imageLiteral(resourceName: "JetmanIdle3"), #imageLiteral(resourceName: "JetmanIdle4"), #imageLiteral(resourceName: "JetmanIdle5"), #imageLiteral(resourceName: "JetmanIdle6"), #imageLiteral(resourceName: "JetmanIdle7"), #imageLiteral(resourceName: "JetmanIdle8"), #imageLiteral(resourceName: "JetmanIdle9")].map { SKTexture(image: $0) }
            texturesForGenderAndState[.flying] = [#imageLiteral(resourceName: "JetmanFlying0"), #imageLiteral(resourceName: "JetmanFlying1"), #imageLiteral(resourceName: "JetmanFlying2"), #imageLiteral(resourceName: "JetmanFlying3"), #imageLiteral(resourceName: "JetmanFlying4"), #imageLiteral(resourceName: "JetmanFlying5"), #imageLiteral(resourceName: "JetmanFlying6"), #imageLiteral(resourceName: "JetmanFlying7"), #imageLiteral(resourceName: "JetmanFlying8"), #imageLiteral(resourceName: "JetmanFlying9")].map { SKTexture(image: $0) }
            texturesForGenderAndState[.dead] = [#imageLiteral(resourceName: "JetmanDead0")].map { SKTexture(image: $0) }
            texturesForGenderAndState[.levelComplete] = texturesForGenderAndState[.flying]
            hasLoadedForGirl = true
        }
    }
}
