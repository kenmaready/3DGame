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
        
        let animKeys = monsterNode.animationKeys.first
        let animPlayer = monsterNode.animationPlayer(forKey: animKeys!)
        let anims = CAAnimation(scnAnimation: (animPlayer?.animation)!)
        
        // run animation
        let runAnimation = Hero.animation(from: anims, startingAtFrame: 31, endingAtFrame: 50)
        runAnimation.repeatCount = .greatestFiniteMagnitude
        runAnimation.fadeInDuration = 0.3
        runAnimation.fadeOutDuration = 0.3
        
        runPlayer = SCNAnimationPlayer(animation: SCNAnimation(caAnimation: runAnimation))
        monsterNode.addAnimationPlayer(runPlayer, forKey: "run")
        
        // jump animation
        let jumpAnimation = Hero.animation(from: anims, startingAtFrame: 81, endingAtFrame: 100)
        jumpAnimation.repeatCount = .greatestFiniteMagnitude
        jumpAnimation.fadeInDuration = 0.3
        jumpAnimation.fadeOutDuration = 0.3
        
        jumpPlayer = SCNAnimationPlayer(animation: SCNAnimation(caAnimation: jumpAnimation))
        monsterNode.addAnimationPlayer(jumpPlayer, forKey: "jump")
        
        monsterNode.removeAllAnimations()
        
        monsterNode.animationPlayer(forKey: "run")?.play()
        
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
            self.physicsBody?.applyForce(SCNVector3Make(0, 2200, 0), asImpulse: true)
        }
    }
    
    func update() {
        if (self.presentation.position.y < 4.0) {
            if (isGrounded == false) {
                playRunAnim()
                isGrounded = true
            }
        } else {
            if (isGrounded == true) {
                playJumpAnim()
                isGrounded = false
            }
        }
    }
    
    func playRunAnim() {
        monsterNode.removeAllAnimations()
        monsterNode.addAnimationPlayer(runPlayer, forKey: "run")
        monsterNode.animationPlayer(forKey: "run")?.play()
    }
    
    func playJumpAnim() {
        monsterNode.removeAllAnimations()
        monsterNode.addAnimationPlayer(jumpPlayer, forKey: "jump")
        monsterNode.animationPlayer(forKey: "jump")?.play()
    }
    
    static func time(atFrame frame: Int, fps: Double = 30) -> TimeInterval {
        return TimeInterval(frame) / fps
    }
    
    static func timeRange(forStartingAtFrame start: Int, endingAtFrame end: Int, fps: Double = 30) -> (offset:TimeInterval, duration:TimeInterval) {
        let startTime = self.time(atFrame: start, fps: fps)
        let endTime = self.time(atFrame: end, fps: fps)
        return (offset: startTime, duration: endTime - startTime)
    }
    
    static func animation(from full: CAAnimation, startingAtFrame start: Int, endingAtFrame end: Int, fps: Double = 30) -> CAAnimation {
        let range = self.timeRange(forStartingAtFrame: start, endingAtFrame: end, fps: fps)
        let animation = CAAnimationGroup()
        let sub = full.copy() as! CAAnimation
        sub.timeOffset = range.offset
        animation.animations = [sub]
        animation.duration = range.duration
        return animation
    }
}
