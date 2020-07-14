//
//  HomeScene.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/1/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SpriteKit
import GameplayKit

class HomeScene: SKScene {
    
    let actionKeys: [String] = [
        "Images",
        "Shapes",
        "Sparkles",
        "Bouncy Balls",
        "Credits"
    ]
    
    let targetScenes: [String: SceneIdentifier] = [
        "Images": .images,
        "Shapes": .boxDrop,
        "Sparkles": .emitters,
        "Bouncy Balls": .rollerBall,
        "Credits": .credits
    ]
    
    private var spinnyNode : SKShapeNode?
    var label: SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.alpha = 0.0
        view.ignoresSiblingOrder = true
        scaleMode = .aspectFill

        let _ = initTitleLabel(sceneHeading: "Home")
        
        // add action labels
        var linkPosition: CGFloat = 0
        for targetKey in actionKeys {
            createActionLink(action: targetKey, position: linkPosition)
            linkPosition+=1
        }
        
        backgroundColor = .white
        
        revealScene()
    }
    
    func createActionLink(action: String, position: CGFloat) {
        print("createActionLink(action: \(action), position: \(position))")
        
        let spacing: CGFloat = 80
        let max: CGFloat = 160
        
        let actionLink = SKLabelNode()
        actionLink.name = action
        actionLink.text = action
        actionLink.fontName = styles.fontName
        actionLink.fontSize = CGFloat(styles.fontSizeLarge)
        
        actionLink.fontColor = SKColor(hex: styles.actionColorHex)
        
        actionLink.position = CGPoint(x: 0, y: max - (spacing * position))
        actionLink.zPosition = 1
        addChild(actionLink)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
    
            if let key = touchedNode.name {
                if let sceneIdentifier: SceneIdentifier = targetScenes[key] {
                    print("key=[\(key)]")
                    print("sceneName=[\(sceneIdentifier.rawValue)]")
                    loadScene(withIdentifier: sceneIdentifier)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
