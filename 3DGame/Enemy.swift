//
//  Enemy.swift
//  3DGame
//
//  Created by Ken Maready on 9/25/22.
//

import SceneKit

class Enemy: SCNNode {
    var _currentScene: GameSCNScene!
    
    init(currentScene: GameSCNScene) {
        super.init()
        self.create(currentScene: currentScene)
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    func create(currentScene: GameSCNScene) {
        self._currentScene = currentScene
        
        let geo = SCNBox(width: 4.0, height: 4.0, length: 4.0, chamferRadius: 0.0)
        geo.firstMaterial?.diffuse.contents = UIColor.yellow
        
        self.geometry = geo
        
        self.position = SCNVector3Make(0, 20.0, 60.0)
        self.physicsBody = SCNPhysicsBody.kinematic()
        self.name = "enemy"
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.hero.rawValue
        
        currentScene.rootNode.addChildNode(self)
    }
    
    func update() {
        self.position.z += -0.9
        
        if (self.position.z - 5.0) < -40 {
            let factor = arc4random_uniform(2) + 1
            
            if factor == 1 {
                self.position = SCNVector3Make(0, 2.0, 60.0)
            } else {
                self.position = SCNVector3Make(0, 15.0, 60.0)
            }
            
            _currentScene.score += 1
            _currentScene.skScene.myLabel.text = "Score: \(_currentScene.score)"
        }
    }
    
}
