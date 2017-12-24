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
        backgroundLayer.setVelocity(value: CGPoint(x: -50.0, y: 0.0))
        
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
