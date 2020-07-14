//
//  CreditsScene.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/2/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {
    
    let appCredits = Bundle.main.decode([AppCredit].self, from: "app-credits.json")

    override func didMove(to view: SKView) {
        self.alpha = 0.0
        view.ignoresSiblingOrder = true
        scaleMode = .aspectFill

        initHomeLabelLink()
        let _ = initTitleLabel(sceneHeading: "Credits")
        
        backgroundColor = .blue

        // add action labels
        let creditLabel: SKLabelNode = SKLabelNode()
        creditLabel.numberOfLines = 25
        
        creditLabel.fontName = styles.fontName
        creditLabel.fontSize = CGFloat(styles.fontSizeSmall)
        creditLabel.fontColor = SKColor(hex: styles.fontColorHex)

        let newLine = "\n"
        let doubleNewLine = "\n\n"

        var creditText = "Our Team"

        for appCredit in appCredits {
            creditText.append(doubleNewLine)
            creditText.append(appCredit.role)
            creditText.append(newLine)
            creditText.append("\(appCredit.firstName) \(appCredit.lastName)")
            
            if appCredit.url.count > 0 {
                creditText.append(newLine)
                creditText.append(appCredit.url)
            }
        }

        creditLabel.text = creditText
        
        creditLabel.horizontalAlignmentMode = .center
        creditLabel.verticalAlignmentMode = .center
        creditLabel.position.x = 0
        creditLabel.position.y = 0
        addChild(creditLabel)
        revealScene()
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
