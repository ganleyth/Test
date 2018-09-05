//
//  GameplayScene.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

protocol GameplaySceneDelegate: class {
    func gameplaySceneDidUpdateScore(newScore: Int)
    func gameplayDidEnd()
}

class GameplayScene: SKScene {
    
    var interactor: GameplaySceneInteractor!
    weak var viewController: UIViewController?
    
    var backgroundLayer: RepeatingLayer?
    var levelLayer: LevelLayer?
    
    lazy var player: Player? = {
        guard
            let view = view,
            let playerPosition = levelLayer?.startingPositionForPlayer else { return nil }
        let player = Player(gender: GameSession.shared.settings.playerGender)
        player.scaleToWindowSize(view.bounds.size, height: true, multiplier: 0.18)
        return player
    }()
    
    var lastTime: TimeInterval?
    
    lazy var scoreKeeper: ScoreKeeper = {
        let scoreKeeper = ScoreKeeper(pointsPerTileMap: 100, scoreCheckpointCount: 50)
        scoreKeeper.delegate = interactor
        return scoreKeeper
    }()
    
    weak var gameplayDelegate: GameplaySceneDelegate?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        interactor = GameplaySceneInteractor(scene: self)
        interactor.viewController = viewController
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
        
        gameplayDelegate?.gameplaySceneDidUpdateScore(newScore: 0)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta = (currentTime - (lastTime ?? currentTime))
        
        if let view = view {
            backgroundLayer?.update(with: delta, in: view.frame.size)
            levelLayer?.update(with: delta, in: view.frame.size)
        }
        lastTime = currentTime
        
        guard
            let levelLayer = levelLayer else { return }
        scoreKeeper.update(forPosition: levelLayer.currentPosition, maxPosition: levelLayer.absoluteTileMapWidth, completedTileMaps: levelLayer.completedTileMaps)

        gameplayDelegate?.gameplaySceneDidUpdateScore(newScore: scoreKeeper.currentScore)
    }
}
