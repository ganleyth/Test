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
    
    var backgroundLayer: RepeatingLayer?
    var foregroundLayer: Layer?
    
    var lastTime: TimeInterval?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        interactor = GameplaySceneInteractor(scene: self)
        interactor.configureAndAddLayers()
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta = (currentTime - (lastTime ?? 0.0)).rounded(toDecimalCount: 2)
        
        if let view = view {
            backgroundLayer?.update(with: delta, in: view.frame.size)
            foregroundLayer?.update(with: delta, in: view.frame.size)
        }
        lastTime = currentTime
    }

}
