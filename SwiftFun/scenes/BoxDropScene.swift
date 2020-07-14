//
//  BoxDropScene.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/11/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import CoreGraphics
import SpriteKit

enum CollisionType: UInt32 {
    case boxCategory = 1
    case circleCategory = 2
    case triangleCategory = 4
    case edgeCategory = 8
}

enum SelectedGravity: CGFloat {
    case earth = -9.8
    case moon = -1.6
    case jupiter = -23.52
}

enum SelectedShape: Int {
    case circle = 1
    case box = 2
    case triangle = 3
}

class BoxDropScene: SKScene, SKPhysicsContactDelegate {
 
    var selectedShape: SelectedShape = .circle
    var selectedGravity: SelectedGravity = .earth
    
    var itemSize: CGFloat = 18.0
    let restitution: CGFloat = 0.9
    
    override func didMove(to view: SKView) {
        self.alpha = 0.0
        view.ignoresSiblingOrder = true
        scaleMode = .aspectFill

        initHomeLabelLink()
        let titleLabel = initTitleLabel(sceneHeading: "Drop a Shape")
        initClearLabel(titleLabel: titleLabel)
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: SelectedGravity.earth.rawValue)
        physicsWorld.speed = 1.0
        physicsWorld.contactDelegate = self
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 5.0
        border.restitution = 0.5
        self.physicsBody = border
        
        let areaWidth: CGFloat = self.view?.bounds.width ?? self.frame.size.width
        let divisor: CGFloat = 15.0
        itemSize = (areaWidth - safeAreaLeft - safeAreaRight) / divisor
        itemSize = itemSize + 2.0

        let r1 = areaWidth.truncatingRemainder(dividingBy: divisor)
        itemSize += r1/divisor

        addShapeSelectors()
        addGravitySelectors()

        self.shapeChange(shape: .circle)
        self.gravityChange(gravity: .earth)

        revealScene()
    }
    
    private func initClearLabel(titleLabel: SKLabelNode) {
        let c: SKLabelNode = SKLabelNode(text: "Clear")
        c.name = "clearBoxes"
        c.fontSize = CGFloat(styles.fontSize)
        c.fontColor = SKColor(hex: styles.actionColorHex)
        c.fontName = styles.fontName
        c.verticalAlignmentMode = .top
        c.horizontalAlignmentMode = .right
        c.position.x = frame.maxX - safeAreaRight
        c.position.y = frame.maxY - safeAreaTop
        c.zPosition = 2.0
        addChild(c)
    }
    
    let dbs: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    let dcs: SKShapeNode = SKShapeNode(circleOfRadius: 25)
    var dts: SKShapeNode!

    let dropBoxesName: String = "dropBoxes"
    let dropCirclesName: String = "dropCircles"
    let dropTrianglesName: String = "dropTriangles"
    
    let earth: SKLabelNode = SKLabelNode(text: "Earth")
    let moon: SKLabelNode = SKLabelNode(text: "Moon")
    let jupiter: SKLabelNode = SKLabelNode(text: "Jupiter")
    
    let earthName: String = "Earth"
    let moonName: String = "Moon"
    let jupiterName: String = "Jupiter"
    
    private func addGravitySelectors() {
        createLabelLink(labelNode: moon, name: moonName, gravity: .moon, pos: 1.0)
        createLabelLink(labelNode: earth, name: earthName, gravity: .earth, pos: 2.0)
        createLabelLink(labelNode: jupiter, name: jupiterName, gravity: .jupiter, pos: 3.0)
    }
    
    private func createLabelLink(labelNode: SKLabelNode, name: String, gravity: SelectedGravity, pos: CGFloat) {
        labelNode.name = name
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = styles.fontName
        labelNode.fontSize = CGFloat(styles.fontSize)
        labelNode.position.x = frame.minX + (frame.width/4) * pos
        labelNode.position.y = frame.maxY - 70 - safeAreaTop
        labelNode.fontColor = .gray
        labelNode.zPosition = 2.0
        addChild(labelNode)
    }
    
    private func addShapeSelectors() {
        let path :UIBezierPath = UIBezierPath.init(triangleIn: CGRect(x: 0, y: 0, width: 50, height: 50))
        dts = SKShapeNode(path: path.cgPath)

        dbs.fillColor = .gray
        dcs.fillColor = .gray
        dts.fillColor = .gray
        addSelectorShapeLink(shapeLink: dbs, name: dropBoxesName, divPos: 1.0)
        addSelectorShapeLink(shapeLink: dcs, name: dropCirclesName, divPos: 2.0)
        addSelectorShapeLink(shapeLink: dts, name: dropTrianglesName, divPos: 3.0)
    }

    private func addSelectorShapeLink(shapeLink: SKShapeNode, name: String, divPos: CGFloat) {
        shapeLink.name = name
        shapeLink.position.x = self.frame.minX + (self.frame.size.width/4) * divPos
        shapeLink.position.y = frame.maxY - (3.0 * shapeLink.frame.width)
        if name == dropTrianglesName {
            shapeLink.position.y = frame.maxY - (3.0 * shapeLink.frame.width) - (shapeLink.frame.height/2)
            shapeLink.position.x = self.frame.minX + (self.frame.size.width/4) * divPos - (shapeLink.frame.width/2)
        }
        shapeLink.zPosition = 2.5
        
        addChild(shapeLink)
    }
        
    var cAlpha: CGFloat {
        0.5
    }

    var colors: [SKColor] {
        [
            SKColor.yellow,
            SKColor.yellow.withAlphaComponent(cAlpha),
            SKColor.red,
            SKColor.red.withAlphaComponent(cAlpha),
            SKColor.blue,
            SKColor.blue.withAlphaComponent(cAlpha),
            SKColor.purple,
            SKColor.purple.withAlphaComponent(cAlpha),
            SKColor.green,
            SKColor.green.withAlphaComponent(cAlpha),
            SKColor.cyan,
            SKColor.cyan.withAlphaComponent(cAlpha),
            SKColor.orange,
            SKColor.magenta
        ]
    }

    var lastColorIndex3: Int = 1
    var lastColorIndex2: Int = 2
    var lastColorIndex1: Int = 3

    private func getColor() -> SKColor {
        var colorIndex: Int = lastColorIndex1
        
        while colorIndex == lastColorIndex1 || colorIndex == lastColorIndex2 || colorIndex == lastColorIndex3 {
            colorIndex = Int.random(in: 0...colors.count-1)
        }

        let color: SKColor = colors[colorIndex]
        lastColorIndex3 = lastColorIndex2
        lastColorIndex2 = lastColorIndex1
        lastColorIndex1 = colorIndex
        return color
    }
    
    private func doDrop(shape: SKShapeNode, category: CollisionType) {
        shape.name = "shape"
        shape.fillColor = getColor()
        shape.strokeColor = .white
        shape.zPosition = 0.5

        shape.run(SKAction.resize(toWidth: itemSize, height: itemSize, duration: 0.0))
        shape.physicsBody!.friction = 1.0
        shape.physicsBody!.restitution = restitution
        shape.physicsBody!.mass = 1.0
        shape.physicsBody!.allowsRotation = true

        shape.physicsBody?.categoryBitMask =  category.rawValue
        shape.physicsBody?.collisionBitMask = CollisionType.boxCategory.rawValue | CollisionType.circleCategory.rawValue | CollisionType.triangleCategory.rawValue | CollisionType.edgeCategory.rawValue
        shape.physicsBody?.contactTestBitMask  = CollisionType.boxCategory.rawValue | CollisionType.circleCategory.rawValue | CollisionType.triangleCategory.rawValue | CollisionType.edgeCategory.rawValue

        self.addChild(shape)
    }
    
    private func dropTriangle(location: CGPoint) {
        
        let sideA: CGFloat = itemSize
        let sideB: CGFloat = itemSize/2
        
        var height: CGFloat = (sideA * sideA) + (sideB * sideB)
        height = height.squareRoot()
        
        let path: UIBezierPath = UIBezierPath.init(triangleIn: CGRect(x: 0, y: 0, width: itemSize, height: height * 0.75))
        let triangle: SKShapeNode = SKShapeNode(path: path.cgPath)

        triangle.position = location
        triangle.position.x = triangle.position.x - triangle.frame.width/2
        triangle.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        
        doDrop(shape: triangle, category: CollisionType.triangleCategory)
    }

    private func dropBall(location: CGPoint) {
        let ball = SKShapeNode(circleOfRadius: itemSize/2)
        
        ball.position = location
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)

        doDrop(shape: ball, category: CollisionType.circleCategory)
    }
    
    private func dropBox(location: CGPoint) {
        let box: SKShapeNode = SKShapeNode(rect: CGRect(x: -itemSize/2, y: -itemSize/2, width: itemSize, height: itemSize))

        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.frame.size)

        doDrop(shape: box, category: CollisionType.boxCategory)
    }
    
    private func clearShapes() {
        for node in self.children {
            if node.name == "shape" {
                node.removeFromParent()
            }
        }
    }
    
    private func gravityChange(gravity: SelectedGravity) {
 
        physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity.rawValue)

        moon.fontColor = .gray
        earth.fontColor = .gray
        jupiter.fontColor = .gray
        
        if gravity == .moon {
            moon.fontColor = .green
            self.physicsBody?.restitution = 0.95
        } else if gravity == .earth {
            earth.fontColor = .green
            self.physicsBody?.restitution = 0.8
        } else if gravity == .jupiter {
            jupiter.fontColor = .green
            self.physicsBody?.restitution = 0.5
        }
        
        clearShapes()
    }
    
    private func shapeChange(shape: SelectedShape) {
        self.selectedShape = shape
        
        dbs.fillColor = .gray
        dcs.fillColor = .gray
        dts.fillColor = .gray
        
        if selectedShape == .box {
            dbs.fillColor = .green
        } else if selectedShape == .circle {
            dcs.fillColor = .green
        } else if selectedShape == .triangle {
            dts.fillColor = .green
        }
    }
    
    private func dropShape(location: CGPoint) {
        
        self.dropping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dropping = false
        }
        
        if selectedShape == .box {
            dropBox(location: location)
        }
        if selectedShape == .circle {
            dropBall(location: location)
        }
        if selectedShape == .triangle {
            dropTriangle(location: location)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNode = atPoint(location)
    
            if touchedNode.name == homeNodeName {
                loadScene(withIdentifier: .home)
            } else if touchedNode.name == "clearBoxes" {
                clearShapes()
            } else if touchedNode.name == dropBoxesName {
                shapeChange(shape: .box)
            } else if touchedNode.name == dropCirclesName {
                shapeChange(shape: .circle)
            } else if touchedNode.name == dropTrianglesName {
                shapeChange(shape: .triangle)
            } else if touchedNode.name == moonName {
                gravityChange(gravity: .moon)
            } else if touchedNode.name == earthName {
                gravityChange(gravity: .earth)
            } else if touchedNode.name == jupiterName {
                gravityChange(gravity: .jupiter)
            } else {
                dropShape(location: location)
            }
        }
    }

    var dropping: Bool = false
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard dropping == false else { return }
        for touch in touches {
            let location = touch.location(in: self)
            self.dropShape(location: location)
        }
    }
}
