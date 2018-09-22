//
//  GameplaySceneInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/16/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit
import AVFoundation
import StoreKit
import GameAnalytics

class GameplaySceneInteractor: Interactor {
    
    var gameplayViewController: GameplayViewController? {
        return viewController as? GameplayViewController
    }
    
    weak var scene: GameplayScene?
    private var currentGameplayMode: GameplayMode = .yetToStart {
        didSet {
            switch currentGameplayMode {
            case .yetToStart:
                enterGameplayMode(.yetToStart)
            case .playing:
                enterGameplayMode(.playing)
            case .gameOver:
                enterGameplayMode(.gameOver)
            }
        }
    }

    var hasCollided = false
    var hasSplashed = false
    var hasEnded = false
    
    private let splashAudioPlayer = AVAudioPlayer.audioPlayer(for: .splash, looping: false)
    private let collisionAudioPlayer = AVAudioPlayer.audioPlayer(for: .crash, looping: false)
    private let descentAudioPlayer = AVAudioPlayer.audioPlayer(for: .descent, looping: false)
    private let musicAudioPlayer = AVAudioPlayer.audioPlayer(for: .music, looping: true, volumeLevel: .low)
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer?
    
    init(scene: GameplayScene) {
        super.init()
        
        self.scene = scene
        addGestureRecognizers()
        
        splashAudioPlayer?.prepareToPlay()
        collisionAudioPlayer?.prepareToPlay()
        collisionAudioPlayer?.delegate = self
        descentAudioPlayer?.prepareToPlay()
        musicAudioPlayer?.play()
    }
    
    func reset() {
        currentGameplayMode = .yetToStart
    }
}

// MARK: - Class initialization
extension GameplaySceneInteractor {
    private func addGestureRecognizers() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(gesture:)))
        longPress.minimumPressDuration = 0.05
        longPressGestureRecognizer = longPress
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
        case .yetToStart:
            player.state = .idle
        case .playing:
            GameAnalytics.addProgressionEvent(with: GAProgressionStatusStart, progression01: "Jetman!", progression02: "Jetman!", progression03: "Jetman!")
            scene.backgroundLayer?.setVelocity(value: CGPoint(x: -50, y: 0))
            scene.levelLayer?.setVelocity(value: CGPoint(x: Constants.TileMapLayer.startingVelocity, y: 0))
        case .gameOver:
            guard !hasEnded else { return }
            scene.backgroundLayer?.setVelocity(value: CGPoint(x: 0, y: 0))
            scene.levelLayer?.setVelocity(value: CGPoint(x: 0, y: 0))
            
            if hasCollided {
                player.state = .dead
                incrementGamesPlayedCountAndRequestAppRating()
            } else {
                if let longPress = longPressGestureRecognizer {
                    scene.view?.removeGestureRecognizer(longPress)
                }
                player.state = .levelComplete
                GameSession.shared.levelManager.currentLevel += 1
            }
            
            hasEnded = true
            scene.gameplayDelegate?.gameplayDidEnd(playerDied: hasCollided)
            musicAudioPlayer?.stop()
            let score = GameSession.shared.scoreKeeper.currentScore
            GameAnalytics.addProgressionEvent(with: GAProgressionStatusComplete, progression01: "Jetman!", progression02: "Jetman!", progression03: "Jetman!", score: score)
        }
    }
}

// MARK: - Contact delegate
extension GameplaySceneInteractor: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let scene = scene else { return }
        guard contact.bodyA.categoryBitMask == Constants.PhysicsBodyCategoryBitMask.player
            || contact.bodyB.categoryBitMask == Constants.PhysicsBodyCategoryBitMask.player else {
                Logger.severe("Player must be one of the physics bodies of the contact", filePath: #file, funcName: #function, lineNumber: #line)
                return
        }
        
        let playerBody = contact.bodyA.categoryBitMask == Constants.PhysicsBodyContactTestBitMask.player ? contact.bodyA : contact.bodyB
        let otherBody = playerBody == contact.bodyA ? contact.bodyB : contact.bodyA
        
        let emitter: SKEmitterNode?
        let feedbackGenerator: CustomUIImpactFeedbackGenerator?
        let audioPlayer: AVAudioPlayer?
        
        switch otherBody.categoryBitMask {
        case Constants.PhysicsBodyCategoryBitMask.platform:
            emitter = nil
            feedbackGenerator = currentGameplayMode == .yetToStart ? CustomUIImpactFeedbackGenerator(style: .medium) : nil
            audioPlayer = nil
        case Constants.PhysicsBodyCategoryBitMask.bottomBoundary:
            emitter = SKEmitterNode(fileNamed: "WaterEmitter") ?? SKEmitterNode()
            emitter?.position = contact.contactPoint - CGPoint(x: 0, y: 10)
            emitter?.numParticlesToEmit = 8
            feedbackGenerator = CustomUIImpactFeedbackGenerator(style: .light)
            audioPlayer = hasSplashed ? nil : splashAudioPlayer
            hasCollided = true
            hasSplashed = true
        case Constants.PhysicsBodyCategoryBitMask.obstacle:
            guard currentGameplayMode == .playing else { return }
            emitter = SKEmitterNode(fileNamed: "ObstacleContactEmitter") ?? SKEmitterNode()
            emitter?.position = contact.contactPoint
            emitter?.numParticlesToEmit = 15
            feedbackGenerator = CustomUIImpactFeedbackGenerator(style: .medium)
            audioPlayer = hasCollided ? nil : collisionAudioPlayer
            hasCollided = true
        case Constants.PhysicsBodyCategoryBitMask.topBoundary:
            guard currentGameplayMode == .playing else { return }
            emitter = SKEmitterNode(fileNamed: "ObstacleContactEmitter") ?? SKEmitterNode()
            emitter?.position = contact.contactPoint
            emitter?.numParticlesToEmit = 15
            emitter?.emissionAngle = CGFloat(Double.pi * 3.0 / 2.0)
            feedbackGenerator = CustomUIImpactFeedbackGenerator(style: .medium)
            audioPlayer = hasCollided ? nil : collisionAudioPlayer
            hasCollided = true
        case Constants.PhysicsBodyCategoryBitMask.finishLine:
            guard currentGameplayMode == .playing else { return }
            emitter = SKEmitterNode(fileNamed: "EndOfLevelCelebration") ?? SKEmitterNode()
            emitter?.position = CGPoint(x: viewController.view.frame.size.width / 2.0,
                                        y: viewController.view.frame.size.height / 2.0)
            feedbackGenerator = CustomUIImpactFeedbackGenerator(style: .medium)
            audioPlayer = nil
        default:
            Logger.severe("Player made contact with invalid body", filePath: #file, funcName: #function, lineNumber: #line)
            fatalError()
        }
        
        if otherBody.categoryBitMask != Constants.PhysicsBodyCategoryBitMask.platform { currentGameplayMode = .gameOver }
        
        if let e = emitter {
            e.zPosition = Constants.ZPosition.emitter.floatValue
            e.setScale(0.4)
            scene.addChild(e)
        }
        if let ap = audioPlayer {
            cancelAllSounds()
            GameSession.shared.soundQueue.addOperation {
                ap.play()
            }
        }
        
        feedbackGenerator?.impactOccurred()
    }
}

// Private
private extension GameplaySceneInteractor {
    func cancelAllSounds() {
        GameSession.shared.soundQueue.cancelAllOperations()
        if splashAudioPlayer?.isPlaying ?? false { splashAudioPlayer?.stop() }
        if collisionAudioPlayer?.isPlaying ?? false { collisionAudioPlayer?.stop() }
        if descentAudioPlayer?.isPlaying ?? false { descentAudioPlayer?.stop() }
    }
    
    func updateChallenge() {}
    
    func incrementGamesPlayedCountAndRequestAppRating() {
        guard var gamesPlayedCount = UserDefaults.standard.value(forKey: Constants.UserDefaults.gamesPlayedCount) as? Int else {
            UserDefaults.standard.set(1, forKey: Constants.UserDefaults.gamesPlayedCount)
            return
        }
        
        gamesPlayedCount += 1
        defer { UserDefaults.standard.set(gamesPlayedCount, forKey: Constants.UserDefaults.gamesPlayedCount) }
        
        if let hasRatedApp = UserDefaults.standard.value(forKey: Constants.UserDefaults.userHasRatedApp) as? Bool {
            guard !hasRatedApp else { return }
            if gamesPlayedCount == 3 {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: Constants.UserDefaults.userHasRatedApp)
            }
        } else {
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.userHasRatedApp)
        }
    }
}

extension GameplaySceneInteractor: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == collisionAudioPlayer {
            GameSession.shared.soundQueue.cancelAllOperations()
            GameSession.shared.soundQueue.addOperation { [weak self] in
                guard let this = self else { return }
                this.descentAudioPlayer?.play()
            }
        }
    }
}
