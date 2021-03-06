//
//  GameViewController.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/1/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'HomeScene.sks'
            if let scene = SKScene(fileNamed: "HomeScene") {
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.preferredFramesPerSecond = 120
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
//            view.showsFields = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
