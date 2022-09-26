//
//  GameSCNScene.swift
//  3DGame
//
//  Created by Ken Maready on 9/25/22.
//

import UIKit
import SceneKit
import SpriteKit

class GameSCNScene: SCNScene, SCNPhysicsContactDelegate {
    var scnView: SCNView!
    var _size: CGSize!
    var hero: Hero!
    var enemy: Enemy!
    var skScene: OverlaySKScene!
    var scrollingBackground = ScrollingBackground()
    
    var score: Int = 0
    var gameOver: Bool = true
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    init(currentView view: SCNView) {
        super.init()
        
        scnView = view
        _size = scnView.bounds.size
        scnView.scene = self
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.systemBlue
        
        self.addLightSourceNode()
        self.addCameraNode()
        self.addGround()
        
        self.hero = Hero(currentScene: self)
        hero.position = SCNVector3Make(0, 5, 0)
        
        self.enemy = Enemy(currentScene: self)
        
        self.physicsWorld.gravity = SCNVector3(0, -500, 3)
        self.physicsWorld.contactDelegate = self
        scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
        
        skScene = OverlaySKScene(size: _size, gameScene: self)
        scnView.overlaySKScene = skScene
        skScene.scaleMode = SKSceneScaleMode.fill
        self.scrollingBackground.create(currentScene: self)
        
        let rain = SCNParticleSystem(named: "rain", inDirectory: nil)
        rain!.warmupDuration = 10
        
        let particleEmitterNode = SCNNode()
        particleEmitterNode.position = SCNVector3(0, 100, 0)
        particleEmitterNode.addParticleSystem(rain!)
        self.rootNode.addChildNode(particleEmitterNode)
    }
    
    func update() {
        hero.update()
        scrollingBackground.update()
        if !gameOver {
            enemy.update()
        }
    }
    
    func heroJump() {
        hero.jump()
    }
    
    func startGame() {
        gameOver = false
        skScene.jumpBtn.isHidden = false
        skScene.myLabel.isHidden = false
        skScene.playBtn.isHidden = true
        skScene.gameOverLabel.isHidden = true
        
        score = 0
        skScene.myLabel.text = "Score: \(score)"
    }
    
    func GameOver() {
        gameOver = true
        
        skScene.jumpBtn.isHidden = true
        skScene.playBtn.isHidden = false
        skScene.gameOverLabel.isHidden = false
        
        enemy.position = SCNVector3Make(0, 2.0, 60.0)
        hero.position = SCNVector3Make(0, 0, 0)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA.name == "hero" && contact.nodeB.name == "enemy") {
            contact.nodeA.physicsBody?.velocity = SCNVector3Zero
            GameOver()
        }
    }
    
    func addLightSourceNode() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        self.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)
    }
    
    func addCameraNode() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 40, z: 100)
        cameraNode.position = SCNVector3(x: -30, y: 5, z: 12)
        cameraNode.eulerAngles.y -= Float(Double.pi/2)
        self.rootNode.addChildNode(cameraNode)
    }
    
    func addFloorNode() {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.position.y = -1.0
        self.rootNode.addChildNode(floorNode)
    }
    
    func addGround() {
        let groundBox = SCNBox(width: 10, height: 2, length: 10, chamferRadius: 0)
        let groundNode = SCNNode(geometry: groundBox)
        
        groundNode.position = SCNVector3Make(0, -1.01, 0)
        groundNode.physicsBody = SCNPhysicsBody.static()
        groundNode.physicsBody?.restitution = 0.0
        groundNode.physicsBody?.friction = 1.0
        groundNode.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        groundNode.physicsBody?.contactTestBitMask = PhysicsCategory.hero.rawValue
        
        groundNode.name = "ground"
        self.rootNode.addChildNode(groundNode)
    }
    
}
