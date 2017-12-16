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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(with delta: TimeInterval, in frameSize: CGSize) {
        super.update(with: delta, in: frameSize)
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
        
        for i in 0..<nodes.count {
            let nodeXPosition = CGFloat(i) * repeatedNode.frame.size.width
            nodes[i].position = CGPoint(x: nodeXPosition, y: 0.0)
            addChild(nodes[i])
        }
    }
    
    func updateNodeRotation(in frameSize: CGSize) {
        guard let farthestAdvancedNode = nodes.first else { return }
        
        if farthestAdvancedNode.position.x < -frameSize.width {
            let distancePastEdge = abs(farthestAdvancedNode.position.x) - frameSize.width
            farthestAdvancedNode.position.x = CGFloat((nodes.count - 1)) * repeatedNode.frame.size.width - distancePastEdge
            nodes.sort { $0.position.x < $1.position.x }
        }
    }
    
}
