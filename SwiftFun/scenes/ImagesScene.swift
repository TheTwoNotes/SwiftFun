//
//  ImagesScene.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/2/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SpriteKit

class ImagesScene: SKScene {
    
    var thisView: SKView!
    let imageItems = Bundle.main.decode([ImageItem].self, from: "image-items.json")
    
    override func didMove(to view: SKView) {
        self.thisView = view

        self.alpha = 0.0
        view.ignoresSiblingOrder = true
        scaleMode = .aspectFill

        initHomeLabelLink()
        let _ = initTitleLabel(sceneHeading: "Images")
        
        backgroundColor = .black
        
        let headingLabelNode: SKLabelNode = SKLabelNode(text: "Images")
        headingLabelNode.fontName = styles.fontName
        headingLabelNode.fontColor = SKColor(hex: styles.fontColorHex)
        headingLabelNode.fontSize = CGFloat(styles.fontSize)
        headingLabelNode.position.x = 0.0
        headingLabelNode.position.y = self.frame.height/4
        addChild(headingLabelNode)
        
        var prevYPos: CGFloat = headingLabelNode.frame.minY
        
        // Add Enemy Ships
        for imageItem in imageItems {
            prevYPos = addImageNode(textureName: imageItem.name, previousYPos: prevYPos, name: imageItem.name, desc: imageItem.description)
        }

        revealScene()
    }
    
    func addImageNode(textureName: String, previousYPos: CGFloat, name: String, desc: String) -> CGFloat {
        let imageNode = SKSpriteNode(texture: SKTexture(imageNamed: textureName))
        
        let spc = self.thisView.frame.height/6
        let yPos = previousYPos - spc
        let xPos = self.thisView.frame.minX - (2 * self.thisView.frame.width/6) - 15

        imageNode.position = CGPoint(x: xPos, y: yPos)
        addChild(imageNode)
        
        let labelNode: SKLabelNode = SKLabelNode(text: "\(name)\n\(desc)")
        labelNode.horizontalAlignmentMode = .left
        labelNode.fontName = styles.fontName
        labelNode.fontSize = CGFloat(styles.fontSizeSmall)
        labelNode.fontColor = SKColor(hex: styles.fontColorHex)
        labelNode.numberOfLines = 2
        labelNode.position.y = imageNode.frame.minY
        labelNode.position.x = 0 - (2 * self.thisView.frame.midX/5) - 20
        addChild(labelNode)
        
        return yPos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
    
            if touchedNode.name == homeNodeName {
                loadScene(withIdentifier: .home)
            }
        }
    }
}
