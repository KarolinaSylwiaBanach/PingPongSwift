//
//  GameScene.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 17/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import SpriteKit
import Alamofire
import GameplayKit

class GameScene: SKScene {
    let URL = "http://karolinabanachios.cba.pl/setResult.php"
    let USER_CREATED = "User created successfully"
    let USER_EXIST = "User already exist"

    var ball = SKSpriteNode()
    var rocketPlayer = SKSpriteNode()
    var rocketEnemy = SKSpriteNode()
    
    let scoreToFinish = 1
    let speedBall = 20
    let formatter1 = DateFormatter()
    var scorePlayer = 0
    var scoreEnemy = 0
    var scorePlayerLabel = SKLabelNode()
    var scPlayerLabel = SKLabelNode()
    var scoreEnemyLabel = SKLabelNode()
    var userName = "Player"
    var firstTime = 0
    var dateString = ""
    let timeStartGame = "timeStartGame.txt", memory="memory.txt", saveDB="saveDB.txt"
    fileprivate var loadPrevious = host_cpu_load_info()
    var timer = Date.timeIntervalSinceReferenceDate

    override func didMove(to view: SKView) {
        
        userName = self.userData?.value(forKey: "namePlayer") as! String
        
        scorePlayerLabel = self.childNode(withName: "scorePlayerLabel") as! SKLabelNode
        scPlayerLabel = self.childNode(withName: "scPlayerLabel") as! SKLabelNode
        scoreEnemyLabel = self.childNode(withName: "scoreEnemyLabel") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        rocketPlayer = self.childNode(withName: "rocketPlayer") as! SKSpriteNode
        rocketEnemy = self.childNode(withName: "rocketEnemy") as! SKSpriteNode
        
        rocketPlayer.position.y = -((self.frame.height/2)-50)
        rocketEnemy.position.y = (self.frame.height/2)-50
        
        ball.physicsBody?.applyImpulse(CGVector(dx:speedBall,dy:speedBall))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        timer = self.userData?.value(forKey: "timer") as! TimeInterval 
        let timer2 = Date.timeIntervalSinceReferenceDate
        setTimeStartGame(startGameTime: "\((timer2-timer) * 1000)")
        startGame()
        report_memory()
        
    }
    func startGame(){
        scoreEnemy = 0
        scorePlayer = 0
        formatter1.dateFormat = "yyyy-MM-dd hh:mm:ss"
        scPlayerLabel.text = "\(userName):"
    }

    func stop (){
        ball.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
        
    }
    
    func restartBall(){
        ball.position = CGPoint (x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
        ball.physicsBody?.velocity = CGVector(dx: 22*speedBall,dy: 22*speedBall)
        
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch in touches{
            let location = touch.location(in: self)
            
            rocketPlayer.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            
            rocketPlayer.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        rocketEnemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.22))
        
        if ball.position.y <= rocketPlayer.position.y - 30{
            scoreEnemy+=1
            restartBall()
        }else if ball.position.y >= rocketEnemy.position.y + 30{
            scorePlayer+=1
            restartBall()
        }
        if scoreEnemy == scoreToFinish{
            stop()
            if(firstTime==0){
                self.winPlayer(title: "Wygrał przeciwnik")
            }
            firstTime+=1
        }else if scorePlayer == scoreToFinish{
            stop()
            if(firstTime==0){
                self.winPlayer(title: "Wygrałeś")
            }
            firstTime+=1
        }
        scoreEnemyLabel.text="\(scoreEnemy)"
        scorePlayerLabel.text="\(scorePlayer)"

    }
    private func json(){
       
        //creating parameters for the post request
        let parameters: Parameters=[
            "name": userName,
            "date": dateString,
            "userScore": "\(scorePlayer)",
            "enemyScore": "\(scoreEnemy)"
        ]
        let timer = Date().timeIntervalSinceReferenceDate
        
        Alamofire.request(self.URL, method: .post, parameters: parameters).responseJSON
        {
            response in
            
            //getting the json value from the server
//            if let result = response.result.value {
//
//                //converting it as NSDictionary
//                let jsonData = result as! NSDictionary
//
//                //displaying the message in label
//                let message = jsonData.value(forKey: "message") as! String
//                print(message)
//            }
        }
       let timer2 =  Date().timeIntervalSinceReferenceDate
        setTimeSaveToDB(saveDB: "\((timer2-timer) * 1000)")

    }
    
    public func winPlayer(title:String){
        let alert = UIAlertController(title: title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Wróć do menu", style: .default, handler: { _ in
            //Action
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuView = storyboard.instantiateViewController(withIdentifier: "menuViewController")
            menuView.view.frame = (self.view?.frame)!
            menuView.view.layoutIfNeeded()
            UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:
                {
                    self.view?.window?.rootViewController = menuView
                    
            }, completion: { completed in
            })
       }))
        
        let currentTopVC: UIViewController? = self.currentTopViewController()
        currentTopVC?.present(alert, animated: true, completion: nil)
        
        let date = Date()
        dateString = formatter1.string(from: date)
        
        json()

    }
    func currentTopViewController() -> UIViewController {
        var topVC: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    func report_memory() {
        var info = mach_task_basic_info()
        let MACH_TASK_BASIC_INFO_COUNT = MemoryLayout<mach_task_basic_info>.stride/MemoryLayout<natural_t>.stride
        var count = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: MACH_TASK_BASIC_INFO_COUNT) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }

        if kerr == KERN_SUCCESS {
            //print("Memory in use (in bytes): \(info.resident_size)")
            let mb = CGFloat(info.resident_size) / 1048576
            setMemory(memory: "\(mb)")
            //setMemory(memory: "\(info.resident_size)")
            
        }
        else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        }
        
    }
    
    func setMemory(memory: String){
        
        var memory2 = getMemory()
        memory2 = memory2+"\n"+memory
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(self.memory)
        //writing
        do {
            try memory2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {}
        }
        print("Ram \(memory2)")
        
    }
    
    func getMemory() -> String  {
        var memory = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(self.memory)
           //reading
           do {
              memory = try String(contentsOf: fileURL, encoding: .utf8)
           }
           catch {}
       }
       return memory;
    }

    func setTimeSaveToDB(saveDB: String){
        
        var saveDB2 = getTimeSaveToDB()
        saveDB2 = saveDB2+"\n"+saveDB
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(self.saveDB)
        //writing
        do {
            try saveDB2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {}
        }
        print("SaveDB \(saveDB2)")
        
    }
    
    func getTimeSaveToDB() -> String  {
        var saveDB = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(self.saveDB)
           //reading
           do {
              saveDB = try String(contentsOf: fileURL, encoding: .utf8)
           }
           catch {}
       }
       return saveDB;
    }
    
    func setTimeStartGame(startGameTime: String){
        
        var timeStartGame2 = getTimeStartGame()
        timeStartGame2 = timeStartGame2+"\n"+startGameTime
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(timeStartGame)
        //writing
        do {
            try timeStartGame2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {}
        }
        print("TimeStartGame \(timeStartGame2)")
        
    }
    func getTimeStartGame() -> String  {
        var startGame = ""

       if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
           let fileURL = dir.appendingPathComponent(timeStartGame)
           //reading
           do {
              startGame = try String(contentsOf: fileURL, encoding: .utf8)
           }
           catch {}
       }
       return startGame;
    }
    
    

}
