//
//  GameplaySceneInteractor.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/16/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class GameplaySceneInteractor: Interactor {
    
    weak var scene: GameplayScene?
    
    init(scene: GameplayScene) {
        super.init()
        self.scene = scene
    }
    
    func configureAndAddLayers() {
        configureBackgroundLayer()
        configureForegroundLayer()
        
        if let scene = scene {
            if let backgroundLayer = scene.backgroundLayer {
                scene.addChild(backgroundLayer)
            }
            
            if let foregroundLayer = scene.foregroundLayer {
                scene.addChild(foregroundLayer)
            }
        }
    }
    
    func configureBackgroundLayer() {
        guard let scene = scene,
            let view = scene.view else { return }
        
        let backgroundNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Background")))
        backgroundNode.scaleToWindowSize(view.frame.size)
        backgroundNode.setAnchorPointToZero()
        let backgroundLayer = RepeatingLayer(nodeCount: 3, repeatedNode: backgroundNode)
        backgroundLayer.setVelocity(value: CGPoint(x: -50.0, y: 0.0))
        
        scene.backgroundLayer = backgroundLayer
    }
    
    func configureForegroundLayer() {
        
    }
}
