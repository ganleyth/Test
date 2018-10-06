//
//  ScoreIncreaseNode.swift
//  Jetman
//
//  Created by Thomas Ganley on 10/6/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import SpriteKit

class ScoreIncreaseNode: SKLabelNode {
    init(scoreIncrease: Int) {
        super.init()
        text = "+\(scoreIncrease)"
        zPosition = Constants.ZPosition.emitter.floatValue
        setupTextLabel()
        addAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private helpers
private extension ScoreIncreaseNode {
    func setupTextLabel() {
        fontName = "Futura-CondensedExtraBold"
        fontSize = 18
        fontColor = UIColor(named: "AppYellow")
    }
    
    func addAction() {
        let verticalTranslationAction = SKAction.moveBy(x: 0, y: 50, duration: 1)
        let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
        let combination = SKAction.group([verticalTranslationAction, alphaAction])
        run(combination) { [weak self] in
            self?.removeFromParent()
        }
    }
}
