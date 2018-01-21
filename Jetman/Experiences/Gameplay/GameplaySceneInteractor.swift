//
//  GameplaySceneInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/16/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class GameplaySceneInteractor {
    
    weak var scene: GameplayScene?
    private var currentGameplayMode: GameplayMode = .yetToStart {
        didSet {
            switch currentGameplayMode {
            case .playing:
                enterGameplayMode(.playing)
            case .gameOver:
                enterGameplayMode(.gameOver)
            default:
                Logger.severe("Cannot change current gameplay mode to .yetToStart", filePath: #file, funcName: #function, lineNumber: #line)
                fatalError()
            }
        }
    }
    
    init(scene: GameplayScene) {
        self.scene = scene
        addGestureRecognizers()
    }
}

// MARK: - Class initialization
extension GameplaySceneInteractor {
    private func addGestureRecognizers() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(gesture:)))
        longPress.minimumPressDuration = 0.1
        scene?.view?.addGestureRecognizer(longPress)
    }
}

// MARK: - Layer initialization
extension GameplaySceneInteractor {
    
    func configureAndAddLayers() {
        configureBackgroundLayer()
        configureLevelLayer()
        
        if let scene = scene {
            if let backgroundLayer = scene.backgroundLayer {
                backgroundLayer.zPosition = CGFloat(Constants.ZPosition.backgroundLayer.rawValue)
                scene.addChild(backgroundLayer)
            }
            
            if let levelLayer = scene.levelLayer {
                levelLayer.zPosition = CGFloat(Constants.ZPosition.foregroundLayer.rawValue)
                scene.addChild(levelLayer)
            }
        }
    }
    
    func configureBackgroundLayer() {
        guard let view = scene?.view else {
            Logger.error("SK view unavailable", filePath: #file, funcName: #function, lineNumber: #line)
            return
        }
        
        let backgroundNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Background")))
        backgroundNode.scaleToWindowSize(view.frame.size)
        backgroundNode.setAnchorPointToZero()
        let backgroundLayer = RepeatingLayer(nodeCount: 3, repeatedNode: backgroundNode)
        scene?.backgroundLayer = backgroundLayer
    }
    
    func configureLevelLayer() {
        guard
            let view = scene?.view,
            let tileSet = SKTileSet(named: "ForegroundTileset") else {
                Logger.error("Could not find the tile set for the foreground layer", filePath: #file, funcName: #function, lineNumber: #line)
                return
        }
        let levelLayer = LevelLayer(windowSize: view.frame.size, tileSet: tileSet)
        scene?.levelLayer = levelLayer
    }
}

// MARK: - Gesture recognizer handling
extension GameplaySceneInteractor {
    @objc private func handleLongPressGestureRecognizer(gesture: UILongPressGestureRecognizer) {
        guard let scene = scene, let player = scene.player else { return }
        switch gesture.state {
        case .began:
            player.beginAscension()
            if currentGameplayMode == .yetToStart {
                currentGameplayMode = .playing
            }
        case .ended:
            player.endAscension()
        default:
            break
        }
    }
}

// MARK: - Gameplay mode handling
extension GameplaySceneInteractor {
    enum GameplayMode {
        case yetToStart
        case playing
        case gameOver
    }
    
    private func enterGameplayMode(_ gameplayMode: GameplayMode) {
        guard let scene = scene,
            let player = scene.player else { return }
        switch gameplayMode {
        case .playing:
            scene.backgroundLayer?.setVelocity(value: CGPoint(x: -50, y: 0))
            scene.levelLayer?.setVelocity(value: CGPoint(x: -150, y: 0))
            player.state = .flying
        case .gameOver:
            scene.backgroundLayer?.setVelocity(value: CGPoint(x: 0, y: 0))
            scene.levelLayer?.setVelocity(value: CGPoint(x: 0, y: 0))
        default:
            Logger.severe("Cannot change current gameplay mode to .yetToStart", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
    }
}

// MARK: - Player handling
extension GameplaySceneInteractor {
    func addPlayer(of gender: Player.Gender) {
        
    }
}
