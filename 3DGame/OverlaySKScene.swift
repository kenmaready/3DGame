//
//  OverlaySKScene.swift
//  3DGame
//
//  Created by Ken Maready on 9/25/22.
//

import SpriteKit

class OverlaySKScene: SKScene {
    var _gameScene: GameSCNScene!
    var myLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var jumpBtn: SKSpriteNode!
    var playBtn: SKSpriteNode!
    

    init(size: CGSize, gameScene: GameSCNScene) {
        super.init(size: size)
        
        _gameScene = gameScene
        
        myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Score: 0"
        myLabel.fontColor = UIColor.white
        myLabel.fontSize = 65
        myLabel.setScale(1.0)
        myLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        self.addChild(myLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 100
        gameOverLabel.setScale(1.0)
        gameOverLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        gameOverLabel.fontColor = .white
        self.addChild(gameOverLabel)
        gameOverLabel.isHidden = true
        
        playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.position = CGPoint(x: size.width * 0.15, y: size.height * 0.2)
        playBtn.scale(to: CGSize(width: 54, height: 54))
        self.addChild(playBtn)
        playBtn.name = "playBtn"
        
        jumpBtn = SKSpriteNode(imageNamed: "jumpBtn")
        jumpBtn.position = CGPoint(x: size.width * 0.9, y: size.height * 0.15)
        self.addChild(jumpBtn)
        jumpBtn.name = "jumpBtn"
        jumpBtn.isHidden = true
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let _node:SKNode = self.atPoint(location)
            
            if (_gameScene.gameOver == false) {
                if (_node.name == "jumpBtn") {
                    _gameScene.heroJump()
                }
            } else {
                if (_node.name == "playBtn") {
                    _gameScene.startGame()
                }
            }
        }
    }
    
}
