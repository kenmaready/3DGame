//
//  Hero.swift
//  3DGame
//
//  Created by Ken Maready on 9/25/22.
//

import SceneKit

class Hero: SCNNode {
    var isGrounded = false
    var monsterNode = SCNNode()
    var jumpPlayer = SCNAnimationPlayer()
    var runPlayer = SCNAnimationPlayer()
    
    init(currentScene: GameSCNScene) {
        super.init()
        self.create(currentScene: currentScene)
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    func create(currentScene: GameSCNScene) {
        let monsterScene: SCNScene = SCNScene(named: "art.scnassets/theDude.DAE")!
        monsterNode = monsterScene.rootNode.childNode(withName: "CATRigHub001", recursively: false)!
        self.addChildNode(monsterNode)
        
        let (minVec, maxVec) = self.boundingBox
        let bound = SCNVector3(x: maxVec.x - minVec.x, y: maxVec.y - minVec.y, z: maxVec.z - minVec.z)
        monsterNode.pivot = SCNMatrix4MakeTranslation(bound.x * 1.1, 0, 0)
        
        let collisionBox = SCNBox(width: 2, height: 8, length: 2, chamferRadius: 0)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: collisionBox, options: nil))
        self.physicsBody?.angularVelocityFactor = SCNVector3(0, 0, 0)
        self.physicsBody?.mass = 20
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.hero.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
        
        self.scale = SCNVector3(0.1, 0.1, 0.1)
        
        self.name = "hero"
        currentScene.rootNode.addChildNode(self)
    }
    
    func jump() {
        if (isGrounded) {
            self.physicsBody?.applyForce(SCNVector3Make(0, 2000, 0), asImpulse: true)
        }
    }
    
    func update() {
        isGrounded = (self.presentation.position.y < 4.0)
    }
}
