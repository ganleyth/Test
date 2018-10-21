//
//  RepeatingLayer.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/9/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import SpriteKit

class RepeatingLayer: Layer {
    let nodeCount: Int
    let repeatedNode: SKSpriteNode
    var nodes: [SKSpriteNode] = []
    
    init(nodeCount: Int, repeatedNode: SKSpriteNode) {
        self.nodeCount = nodeCount
        self.repeatedNode = repeatedNode
        
        super.init()

        setupRepeatingNodes()
        
        nodes.forEach { $0.lightingBitMask = Constants.Lighting.fireModeLightBitMask }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(with delta: TimeInterval, in frameSize: CGSize) {
        super.update(with: delta, in: frameSize)
        
        for i in 1..<nodes.count {
            nodes[i].position.x = nodes[i-1].frame.maxX + Constants.RepeatingLayer.repeatedNodeOffset
        }
        
        updateNodeRotation(in: frameSize)
    }
}

// MARK: - Helper methods
extension RepeatingLayer {
    
    func setupRepeatingNodes() {
        for _ in 0..<self.nodeCount {
            if let copy = repeatedNode.copy() as? SKSpriteNode {
                nodes.append(copy)
            }
        }
        
        guard let mostAdvancedNode = nodes.first else { return }
        mostAdvancedNode.position = CGPoint.zero
        addChild(mostAdvancedNode)
        
        for i in 1..<nodes.count {
            let nodeXPosition = nodes[i-1].frame.maxX + Constants.RepeatingLayer.repeatedNodeOffset
            nodes[i].position = CGPoint(x: nodeXPosition, y: 0.0)
            addChild(nodes[i])
        }
    }
    
    func updateNodeRotation(in frameSize: CGSize) {
        guard let mostAdvancedNode = nodes.first,
            let leastAdvancedNode = nodes.last else { return }
        
        if mostAdvancedNode.frame.maxX < -1 {
            mostAdvancedNode.position.x = leastAdvancedNode.frame.maxX + Constants.RepeatingLayer.repeatedNodeOffset
            nodes.sort { $0.position.x < $1.position.x }
        }
    }
}
