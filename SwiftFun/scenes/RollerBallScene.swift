//
//  RollerBallScene.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/13/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import CoreGraphics
import SpriteKit
import CoreMotion


class RollerBallScene: SKScene, SKPhysicsContactDelegate {

    var colors: [SKColor] {
        [
            SKColor.yellow,
            SKColor.red,
            SKColor.blue,
            SKColor.purple,
            SKColor.green,
            SKColor.cyan,
            SKColor.orange,
            SKColor.magenta
        ]
    }

    enum CollisionType: UInt32 {
        case ballCategory = 1
        case barrierCategory = 2
        case edgeCategory = 8
    }

    let motionManager = CMMotionManager()
    let accelerationScale: Double = 25.0

    override func didMove(to view: SKView) {
        self.alpha = 0.0
        view.ignoresSiblingOrder = true
        scaleMode = .aspectFill

        print("1")
        initHomeLabelLink()
        print("2")

        let _ = initTitleLabel(sceneHeading: "Bouncy Balls")
        print("3")

        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.speed = 1.0
        physicsWorld.contactDelegate = self
        print("4")

        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0.0
        border.restitution = 0.0
        border.isDynamic = false
        self.physicsBody = border
        print("5")

        for index in 1...colors.count {
            dropBall(index: index)
        }
        
        motionManager.startAccelerometerUpdates()
        
        revealScene()
    }

    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {

            let gravityForce: Double = 9.8
            let xTilt: Double = accelerometerData.acceleration.x
            let yTilt: Double = accelerometerData.acceleration.y

            print("xTilt=[ \(xTilt) ]")
            print("yTilt=[ \(yTilt) ]")

            physicsWorld.gravity = CGVector(dx: xTilt * gravityForce, dy: yTilt * gravityForce)
        }
    }

    private func dropBall(index: Int) {
    
        print("dropBall()")
        let ballSize: CGFloat = 4.0 * CGFloat(index)
        
        let ball: SKShapeNode = SKShapeNode(circleOfRadius: ballSize)


        let posX: CGFloat = frame.minX + (CGFloat(index) * ballSize)
        let posY: CGFloat = frame.minY + (CGFloat(index) * ballSize)
        
        ball.position.x = posX
        ball.position.y = posY
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize)

        print("db-1")
        ball.name = "shape"
        ball.fillColor = colors[index-1]
        ball.strokeColor = .white
        ball.zPosition = 1.0

        print("db-2")

        ball.physicsBody!.friction = 0.2
        ball.physicsBody!.restitution = 0.8
        ball.physicsBody!.mass = 40.0/CGFloat(index)
        ball.physicsBody!.allowsRotation = true

        print("db-3")

        ball.physicsBody?.categoryBitMask =  CollisionType.ballCategory.rawValue
        ball.physicsBody?.collisionBitMask = CollisionType.ballCategory.rawValue | CollisionType.barrierCategory.rawValue | CollisionType.edgeCategory.rawValue
        ball.physicsBody?.contactTestBitMask  = CollisionType.ballCategory.rawValue | CollisionType.barrierCategory.rawValue | CollisionType.edgeCategory.rawValue

        print("db-4")

        self.addChild(ball)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNode = atPoint(location)
    
            if touchedNode.name == homeNodeName {
                motionManager.stopDeviceMotionUpdates()
                loadScene(withIdentifier: .home)
            }
        }
    }
}
