//
//  Player.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit
import AVKit

class Player: SKSpriteNode {
    let gender: Gender
    private var isAscending = false
    var state: State = .idle {
        didSet {
            if state != oldValue {
                updateRotation()
                updateAnimationAndPhysics()
                if state == .dead || state == .levelComplete { propulsionSoundPlayer?.stop() }
            }
        }
    }
    
    private var stateRestitution: CGFloat {
        switch state {
        case .flying:
            return 1.0
        default:
            return 0.0
        }
    }
    
    let propulsionSoundPlayer = AVAudioPlayer.audioPlayer(for: .propulsion, looping: true)
    
    private lazy var smokeEmitter: SKEmitterNode? = {
        guard let emitter = SKEmitterNode(fileNamed: "JetpackSmokeEmitter") else { return nil }
        emitter.position = CGPoint(x: -22, y: -27)
        emitter.zPosition = Constants.ZPosition.emitter.floatValue
        emitter.name = Constants.Player.smokeEmitterName
        emitter.particleBirthRate = 0
        return emitter
    }()
    
    private lazy var fireModeLight: SKLightNode = {
        let light = SKLightNode()
        light.position = CGPoint(x: -22, y: -27)
        light.zPosition = Constants.ZPosition.light.floatValue
        light.name = Constants.Player.lightName
        light.lightColor = .yellow
        light.ambientColor = .black
        light.falloff = 1
        light.isEnabled = false
        light.categoryBitMask = Constants.Lighting.fireModeLightBitMask
        return light
    }()

    init(gender: Gender) {
        self.gender = gender
        let texture = SKTexture(image: gender == .boy ? #imageLiteral(resourceName: "JetmanIdle0") : #imageLiteral(resourceName: "MsJetmanIdle0"))
        super.init(texture: texture, color: .clear, size: texture.size())
        zPosition = Constants.ZPosition.playerAndObstacles.floatValue
        propulsionSoundPlayer?.prepareToPlay()
        if let se = smokeEmitter { addChild(se) }
        addChild(fireModeLight)
        lightingBitMask = Constants.Lighting.fireModeLightBitMask
        
        updateAnimationAndPhysics()
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterFireMode), name: Constants.Notifications.fireModeBegin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(exitFireMode), name: Constants.Notifications.fireModeEnd, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this intializer")
    }
}

// MARK: - Player states
extension Player {
    
    private func updateRotation() {
        if state == .flying {
            let rotation = SKAction.rotate(toAngle: CGFloat(-10.0).degreesToRadians, duration: 0.1)
            run(rotation)
        }
    }
    
    private func updateAnimationAndPhysics() {
        // Update physics
        guard
            let textures = SpriteLoader.shared.texturesForGenderAndState[state],
            let firstTexture = textures.first else {
                Logger.severe("Sprites not property loaded for state", filePath: #file, funcName: #function, lineNumber: #line)
                return
        }
        
        removeAction(forKey: Constants.Player.animationKey)
        
        switch state {
        case .flying:
            let inverseForPlatfom = ~Constants.PhysicsBodyCategoryBitMask.platform
            if let collisionBitmask = physicsBody?.collisionBitMask {
                physicsBody?.collisionBitMask = collisionBitmask & inverseForPlatfom
            }
            // Update action
            let animation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.08))
            run(animation, withKey: Constants.Player.animationKey)
            
            // Update physics
            physicsBody = SKPhysicsBody(texture: firstTexture, size: frame.size)
            setPhysicsBodyProperties()
        case .levelComplete:
            endLevel()
        case .dead:
            self.texture = firstTexture
            if isAscending { endAscension() }
        default:
            physicsBody = SKPhysicsBody(texture: firstTexture, size: frame.size)
            setPhysicsBodyProperties()
            
            // Update action
            let animation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.08))
            run(animation, withKey: Constants.Player.animationKey)
        }
    }
    
    private func setPhysicsBodyProperties() {
        guard let physicsBody = physicsBody else { return }
        physicsBody.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.player
        physicsBody.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.boundariesAndObstacles
        physicsBody.collisionBitMask = Constants.PhysicsBodyCollisionBitMask.platform
        physicsBody.restitution = stateRestitution
        physicsBody.friction = 0.0
    }
    
    private func removeSmokeEmitter() {
        guard let emitter = childNode(withName: Constants.Player.smokeEmitterName) else { return }
        emitter.removeFromParent()
    }
    
    enum Gender {
        case boy
        case girl
    }
    
    enum State {
        case idle
        case flying
        case levelComplete
        case dead
    }
}

// MARK: - Gameplay
extension Player {
    func beginAscension() {
        isAscending = true
        physicsBody?.affectedByGravity = false
        physicsBody?.velocity = CGVector.zero
        let ascend = SKAction.moveBy(x: 0.0, y: 20.0, duration: 0.1)
        let repeatAscend = SKAction.repeatForever(ascend)
        let rotate = SKAction.rotate(byAngle: CGFloat(10.0).degreesToRadians, duration: 0.15)
        run(rotate)
        run(repeatAscend, withKey: Constants.Player.ascendKey)
        
        GameSession.shared.soundQueue.addOperation { [weak self] in
            guard let this = self else { return }
            this.propulsionSoundPlayer?.play()
        }
        
        smokeEmitter?.particleBirthRate = 6
    }
    
    func endAscension() {
        if state != .dead { physicsBody?.velocity = CGVector.zero }
        physicsBody?.affectedByGravity = true
        removeAction(forKey: Constants.Player.ascendKey)
        let rotate = SKAction.rotate(byAngle: CGFloat(-10.0).degreesToRadians, duration: 0.15)
        run(rotate)
        isAscending = false

        GameSession.shared.soundQueue.addOperation { [weak self] in
            guard let this = self else { return }
            this.propulsionSoundPlayer?.pause()
        }
        
        smokeEmitter?.particleBirthRate = 0
    }
    
    func endLevel() {
        physicsBody = nil
        removeAction(forKey: Constants.Player.ascendKey)
        isAscending = false
        
        GameSession.shared.soundQueue.addOperation { [weak self] in
            guard let this = self else { return }
            this.propulsionSoundPlayer?.pause()
        }
        
        smokeEmitter?.particleBirthRate = 0
    }
    
    @objc private func enterFireMode() {
        fireModeLight.isEnabled = true
    }
    
    @objc private func exitFireMode() {
        fireModeLight.isEnabled = false
    }
}
