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
    var state: State = .idle {
        didSet {
            updateAnimation()
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
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: textureSize)
        physicsBody?.categoryBitMask = Constants.PhysicsBodyCategoryBitMask.player.rawValue
        physicsBody?.contactTestBitMask = Constants.PhysicsBodyContactTestBitMask.bottomBoundaryAndObstacle.rawValue
        physicsBody?.restitution = 0.0
        
        zPosition = Constants.ZPosition.playerAndObstacles.floatValue
        
        updateAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this intializer")
    }
}

// MARK: - Player states
extension Player {
    
    private func updateAnimation() {
        removeAction(forKey: Constants.Player.animationKey)
        let animation = SKAction.repeatForever(SKAction.animate(with: texturesForGenderAndState, timePerFrame: 0.08))
        run(animation, withKey: Constants.Player.animationKey)
    }
    
    private var texturesForGenderAndState: [SKTexture] {
        let images: [UIImage]
        switch (gender, state) {
        case (.boy, .idle):
            images = [#imageLiteral(resourceName: "JetmanIdle0"), #imageLiteral(resourceName: "JetmanIdle1"), #imageLiteral(resourceName: "JetmanIdle2"), #imageLiteral(resourceName: "JetmanIdle3"), #imageLiteral(resourceName: "JetmanIdle4"), #imageLiteral(resourceName: "JetmanIdle5"), #imageLiteral(resourceName: "JetmanIdle6"), #imageLiteral(resourceName: "JetmanIdle7"), #imageLiteral(resourceName: "JetmanIdle8"), #imageLiteral(resourceName: "JetmanIdle9")]
        case (.boy, .flying):
            images = [#imageLiteral(resourceName: "JetmanFlying0"), #imageLiteral(resourceName: "JetmanFlying1"), #imageLiteral(resourceName: "JetmanFlying2"), #imageLiteral(resourceName: "JetmanFlying3"), #imageLiteral(resourceName: "JetmanFlying4"), #imageLiteral(resourceName: "JetmanFlying5"), #imageLiteral(resourceName: "JetmanFlying6"), #imageLiteral(resourceName: "JetmanFlying7"), #imageLiteral(resourceName: "JetmanFlying8"), #imageLiteral(resourceName: "JetmanFlying9")]
        case (.boy, .dead):
            images = [#imageLiteral(resourceName: "JetmanDead0"), #imageLiteral(resourceName: "JetmanDead1"), #imageLiteral(resourceName: "JetmanDead2"), #imageLiteral(resourceName: "JetmanDead3"), #imageLiteral(resourceName: "JetmanDead4"), #imageLiteral(resourceName: "JetmanDead5"), #imageLiteral(resourceName: "JetmanDead6"), #imageLiteral(resourceName: "JetmanDead7")]
        case (.girl, .idle):
            images = [#imageLiteral(resourceName: "MsJetmanIdle0"), #imageLiteral(resourceName: "MsJetmanIdle1"), #imageLiteral(resourceName: "MsJetmanIdle2"), #imageLiteral(resourceName: "MsJetmanIdle3"), #imageLiteral(resourceName: "MsJetmanIdle4"), #imageLiteral(resourceName: "MsJetmanIdle5"), #imageLiteral(resourceName: "MsJetmanIdle6"), #imageLiteral(resourceName: "MsJetmanIdle7"), #imageLiteral(resourceName: "MsJetmanIdle8"), #imageLiteral(resourceName: "MsJetmanIdle9")]
        case (.girl, .flying):
            images = [#imageLiteral(resourceName: "MsJetmanFlying0"), #imageLiteral(resourceName: "MsJetmanFlying1"), #imageLiteral(resourceName: "MsJetmanFlying2"), #imageLiteral(resourceName: "MsJetmanFlying3"), #imageLiteral(resourceName: "MsJetmanFlying4"), #imageLiteral(resourceName: "MsJetmanFlying5"), #imageLiteral(resourceName: "MsJetmanFlying6"), #imageLiteral(resourceName: "MsJetmanFlying7"), #imageLiteral(resourceName: "MsJetmanFlying8"), #imageLiteral(resourceName: "MsJetmanFlying9")]
        case (.girl, .dead):
            images = [#imageLiteral(resourceName: "MsJetmanDead0"), #imageLiteral(resourceName: "MsJetmanDead1"), #imageLiteral(resourceName: "MsJetmanDead2"), #imageLiteral(resourceName: "MsJetmanDead3"), #imageLiteral(resourceName: "MsJetmanDead4"), #imageLiteral(resourceName: "MsJetmanDead5"), #imageLiteral(resourceName: "MsJetmanDead6"), #imageLiteral(resourceName: "MsJetmanDead7")]
        }
        
        return images.flatMap { SKTexture(image: $0) }
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
        physicsBody?.affectedByGravity = false
        physicsBody?.velocity = CGVector.zero
        let ascend = SKAction.moveBy(x: 0.0, y: 20.0, duration: 0.1)
        let repeatAscend = SKAction.repeatForever(ascend)
        run(repeatAscend, withKey: Constants.Player.ascendKey)
    }
    
    func endAscension() {
        physicsBody?.velocity = CGVector.zero
        physicsBody?.affectedByGravity = true
        removeAction(forKey: Constants.Player.ascendKey)
    }
}
