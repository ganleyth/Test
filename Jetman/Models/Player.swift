//
//  Player.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    let gender: Gender
    private var isAscending = false
    var state: State = .idle {
        didSet {
            if state != oldValue {
                updateRotation()
                updateAnimationAndPhysics()
                switch state {
                case .flying: addSmokeEmitter()
                case .dead: removeSmokeEmitter()
                default: break
                }
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
    
    private var textureWidth: CGFloat
    private var textureAspectRatio: CGFloat
    
    private var textureSize: CGSize {
        return CGSize(width: textureWidth, height: textureWidth / textureAspectRatio)
    }
    
    init(gender: Gender) {
        self.gender = gender
        let texture = SKTexture(image: gender == .boy ? #imageLiteral(resourceName: "JetmanIdle0") : #imageLiteral(resourceName: "MsJetmanIdle0"))
        textureWidth = Constants.Player.defaultWidthIdle
        textureAspectRatio = texture.size().width / texture.size().height
        
        super.init(texture: texture, color: .clear, size: textureSize)
        zPosition = Constants.ZPosition.playerAndObstacles.floatValue
        
        updateAnimationAndPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this intializer")
    }
}

// MARK: - Player states
extension Player {
    
    private func updateRotation() {
        if state == .flying {
            let rotation = SKAction.rotate(toAngle: CGFloat(-30.0).degreesToRadians, duration: 0.3)
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
        case .dead:
            self.texture = firstTexture
            if isAscending { endAscension() }
        default:
            physicsBody = SKPhysicsBody(texture: firstTexture, size: textureSize)
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
    
    private func addSmokeEmitter() {
        guard let emitter = SKEmitterNode(fileNamed: "JetpackSmokeEmitter") else { return }
        emitter.position = CGPoint(x: -22, y: -27) * Constants.Player.defaultWidthScaleFlying
        emitter.zPosition = Constants.ZPosition.emitter.floatValue
        emitter.setScale(0.4)
        emitter.emissionAngle = CGFloat(Double.pi)
        emitter.name = Constants.Player.smokeEmitterName
        addChild(emitter)
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
    }
    
    func endAscension() {
        if state != .dead { physicsBody?.velocity = CGVector.zero }
        physicsBody?.affectedByGravity = true
        removeAction(forKey: Constants.Player.ascendKey)
        let rotate = SKAction.rotate(byAngle: CGFloat(-10.0).degreesToRadians, duration: 0.15)
        run(rotate)
        isAscending = false
    }
}
