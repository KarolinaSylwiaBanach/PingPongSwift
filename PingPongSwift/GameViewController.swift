//
//  GameViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 20/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var namePlayer = ""
    var timer = Date.timeIntervalSinceReferenceDate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                // Present the scene
                scene.userData = NSMutableDictionary()
                scene.userData?.setObject(namePlayer , forKey: "namePlayer" as NSCopying)
                scene.userData?.setObject(timer , forKey: "timer" as NSCopying)
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
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
