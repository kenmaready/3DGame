//
//  GameViewController.swift
//  3DGame
//
//  Created by Ken Maready on 9/25/22.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    var gameSCNScene: GameSCNScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scnView = view as! SCNView
        scnView.delegate = self
        gameSCNScene = GameSCNScene(currentView: scnView)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        gameSCNScene.update()
    }
}
