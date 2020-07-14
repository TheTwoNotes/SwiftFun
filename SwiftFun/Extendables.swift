//
//  Extendables.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/1/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

enum SceneIdentifier: String {
    case images = "ImagesScene"
    case boxDrop = "BoxDropScene"
    case emitters = "EmittersScene"
    case credits = "CreditsScene"
    case rollerBall = "RollerBallScene"
    case home = "HomeScene"
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}

extension UIBezierPath {
  // 1
  convenience init(triangleIn rect: CGRect) {
    self.init()
    // 2
    let topOfTriangle = CGPoint(x: rect.width / 2, y: rect.height)
    let bottomLeftOfTriangle = CGPoint(x: 0, y: 0)
    let bottomRightOfTriangle = CGPoint(x: rect.width, y: 0)
    // 3
    self.move(to: topOfTriangle)
    self.addLine(to: bottomLeftOfTriangle)
    self.addLine(to: bottomRightOfTriangle)
    // 4
    self.close()
  }
}

extension SKScene {
    
    var homeNodeName: String {
        return "Home"
    }

    private var minimumEdgePadding: CGFloat {
        return 15
    }
    
    var safeAreaRight: CGFloat {
        return max(self.view!.safeAreaInsets.right, minimumEdgePadding)
    }
    
    var safeAreaLeft: CGFloat {
        return max(self.view!.safeAreaInsets.left, minimumEdgePadding)
    }

    var safeAreaTop: CGFloat {
        return max(self.view!.safeAreaInsets.top, minimumEdgePadding)
    }
    
    var safeAreaBottom: CGFloat {
        return max(self.view!.safeAreaInsets.bottom, minimumEdgePadding)
    }
        
    var styles: StylesSheet {
        return Bundle.main.decode(StylesSheet.self, from: "styles-sheet.json")
    }

    func loadScene(withIdentifier identifier: SceneIdentifier) {

        let scene: SKScene

        switch identifier {
            case .images:
                scene = ImagesScene(fileNamed: identifier.rawValue)!
            case .boxDrop:
                scene = BoxDropScene(fileNamed: identifier.rawValue)!
            case .emitters:
                scene = EmittersScene(fileNamed: identifier.rawValue)!
            case .rollerBall:
                scene = RollerBallScene(fileNamed: identifier.rawValue)!
            case .credits:
                scene = CreditsScene(fileNamed: identifier.rawValue)!
            case .home:
                scene = HomeScene(fileNamed: identifier.rawValue)!
        }
        
        self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    func revealScene() {
        self.run(SKAction.fadeIn(withDuration: 0.8))
    }
    
    func initTitleLabel(sceneHeading: String) -> SKLabelNode {
        let titleLabel: SKLabelNode = SKLabelNode(text: "")

        titleLabel.alpha = 0.0
        titleLabel.text = sceneHeading
        titleLabel.fontName = styles.fontNameItalic
        titleLabel.fontSize = CGFloat(styles.fontSizeLarge)
        titleLabel.fontColor = SKColor(hex: styles.fontColorHex)
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position.x = .zero
        titleLabel.position.y = frame.maxY - titleLabel.frame.height - safeAreaTop - 5
        titleLabel.zPosition = 1.5
        addChild(titleLabel)

        titleLabel.run(SKAction.fadeIn(withDuration: 0.0))
        return titleLabel
    }

    func initHomeLabelLink() {
        let homeLabelLink : SKLabelNode = SKLabelNode(text: "Done")

        homeLabelLink.name = homeNodeName
        homeLabelLink.fontColor = SKColor(hex: styles.actionColorHex)
        homeLabelLink.fontSize = CGFloat(styles.fontSize)
        homeLabelLink.fontName = styles.fontName
        
        homeLabelLink.horizontalAlignmentMode = .left
        homeLabelLink.position.x = frame.minX + safeAreaLeft
        homeLabelLink.position.y = frame.maxY - safeAreaTop - homeLabelLink.frame.height

        homeLabelLink.alpha = 1.0
        homeLabelLink.zPosition = 1.5
        
        addChild(homeLabelLink)
    }
}
