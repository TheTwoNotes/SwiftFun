//
//  EmittersScene.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/1/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SpriteKit

class EmittersScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        self.alpha = 0.0
        view.ignoresSiblingOrder = true
        scaleMode = .aspectFill

        initHomeLabelLink()
        let _ = initTitleLabel(sceneHeading: "Sparkles")
        
        backgroundColor = .black
        addEmitter()
        
        revealScene()
    }
    
    private func fadeAndRemove(node: SKNode) {
        let seq = SKAction.sequence([SKAction.fadeOut(withDuration: 2.0), .removeFromParent()])
        node.run(seq)
    }
    
    private func addSparkler(position: CGPoint) {
        if let sparkle = SKEmitterNode(fileNamed: "Sparkler") {
            sparkle.position = position
            addChild(sparkle)
            
            self.fadeAndRemove(node: sparkle)
        }
    }
    
    private func addEmitter() {
        if let particles = SKEmitterNode(fileNamed: "Ambience") {
            particles.zPosition = -2.0
            particles.advanceSimulationTime(100)

            addChild(particles)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
    
            if touchedNode.name == homeNodeName {
                loadScene(withIdentifier: .home)
            } else {
                addSparkler(position: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            addSparkler(position: location)
        }
    }
}
