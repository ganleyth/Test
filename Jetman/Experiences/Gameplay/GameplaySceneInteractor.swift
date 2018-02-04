//
//  GameplaySceneInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/16/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class GameplaySceneInteractor: NSObject {
    
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
        super.init()
        
        self.scene = scene
        addGestureRecognizers()
    }
}

// MARK: - Class initialization
extension GameplaySceneInteractor {
    private func addGestureRecognizers() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(gesture:)))
        longPress.minimumPressDuration = 0.05
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
            switch currentGameplayMode {
            case .yetToStart:
                currentGameplayMode = .playing
                fallthrough
            case .playing:
                player.state = .flying
                player.beginAscension()
            default: break
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
        guard
            let scene = scene,
            let player = scene.player else { return }
        switch gameplayMode {
        case .playing:
            scene.backgroundLayer?.setVelocity(value: CGPoint(x: -50, y: 0))
            scene.levelLayer?.setVelocity(value: CGPoint(x: -200, y: 0))
        case .gameOver:
            scene.backgroundLayer?.setVelocity(value: CGPoint(x: 0, y: 0))
            scene.levelLayer?.setVelocity(value: CGPoint(x: 0, y: 0))
            player.state = .dead
            
        default:
            Logger.severe("Cannot change current gameplay mode to .yetToStart", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
    }
}

// MARK: - Contact delegate
extension GameplaySceneInteractor: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        defer { currentGameplayMode = .gameOver }
        guard let scene = scene else { return }
        guard contact.bodyA.categoryBitMask == Constants.PhysicsBodyCategoryBitMask.player
            || contact.bodyB.categoryBitMask == Constants.PhysicsBodyCategoryBitMask.player else {
                Logger.severe("Player must be one of the physics bodies of the contact", filePath: #file, funcName: #function, lineNumber: #line)
                return
        }
        
        let playerBody = contact.bodyA.categoryBitMask == Constants.PhysicsBodyContactTestBitMask.player ? contact.bodyA : contact.bodyB
        let otherBody = playerBody == contact.bodyA ? contact.bodyB : contact.bodyA
        
        let emitter: SKEmitterNode
        switch otherBody.categoryBitMask {
        case Constants.PhysicsBodyCategoryBitMask.bottomBoundary:
            emitter = SKEmitterNode(fileNamed: "WaterEmitter") ?? SKEmitterNode()
            emitter.position = contact.contactPoint - CGPoint(x: 0, y: 10)
            emitter.numParticlesToEmit = 8
        case Constants.PhysicsBodyCategoryBitMask.obstacle:
            guard currentGameplayMode == .playing else { return }
            emitter = SKEmitterNode(fileNamed: "ObstacleContactEmitter") ?? SKEmitterNode()
            emitter.position = contact.contactPoint
            emitter.numParticlesToEmit = 15
        case Constants.PhysicsBodyCategoryBitMask.topBoundary:
            guard currentGameplayMode == .playing else { return }
            emitter = SKEmitterNode(fileNamed: "ObstacleContactEmitter") ?? SKEmitterNode()
            emitter.position = contact.contactPoint
            emitter.numParticlesToEmit = 15
            emitter.emissionAngle = CGFloat(Double.pi * 3.0 / 2.0)
        default:
            Logger.severe("Player made contact with invalid body", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
        
        emitter.zPosition = Constants.ZPosition.emitter.floatValue
        emitter.setScale(0.4)
        scene.addChild(emitter)
    }
}
