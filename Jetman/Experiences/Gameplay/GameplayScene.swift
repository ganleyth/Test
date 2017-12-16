//
//  GameplayScene.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var interactor: GameplaySceneInteractor!
    
    var backgroundLayer: Layer?
    var foregroundLayer: Layer?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        interactor = GameplaySceneInteractor(scene: self)
        interactor.configureAndAddLayers()
    }

}
