//
//  GameplayScene.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var playerGender: Player.Gender = .boy
    
    var interactor: GameplaySceneInteractor!
    
    var backgroundLayer: RepeatingLayer?
    var levelLayer: LevelLayer?
    
    lazy var player: Player? = {
        guard let playerPosition = levelLayer?.startingPositionForPlayer else { return nil }
        let player = Player(gender: playerGender)
        return player
    }()
    
    var lastTime: TimeInterval?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        interactor = GameplaySceneInteractor(scene: self)
        interactor.configureAndAddLayers()
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        physicsWorld.contactDelegate = interactor
        
        guard
            let player = player,
            let playerPosition = levelLayer?.startingPositionForPlayer else {
            Logger.severe("Player not created successfully", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
        
        player.position = playerPosition
        addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta = (currentTime - (lastTime ?? currentTime))
        
        if let view = view {
            backgroundLayer?.update(with: delta, in: view.frame.size)
            levelLayer?.update(with: delta, in: view.frame.size)
        }
        lastTime = currentTime
    }

}
