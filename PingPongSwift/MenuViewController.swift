//
//  MenuViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 30/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController{
    
    var namePlayer = ""
    
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var getResultButton: UIButton!
    @IBOutlet weak var getMyResultButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var urlPlayer = false
   
    let loginVC = LoginViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        gameButton.layer.cornerRadius = 8.0
        getResultButton.layer.cornerRadius = 8.0
        getMyResultButton.layer.cornerRadius = 8.0
        editButton.layer.cornerRadius = 8.0
        logOutButton.layer.cornerRadius = 8.0
        if(namePlayer.isEmpty){
            namePlayer = loginVC.getName()
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.shouldPerformSegue(withIdentifier: "menuViewController", sender: self)
    }
    @IBAction func gameButton(_ sender: Any) {
        performSegue(withIdentifier: "goToGame", sender: self)
    }
    
    @IBAction func goToResultButton(_ sender: Any) {
        urlPlayer = false
        performSegue(withIdentifier: "Url", sender: self)
    }
    
    @IBAction func goToMyResultButton(_ sender: Any) {
        urlPlayer = true
        performSegue(withIdentifier: "Url", sender: self)
    }
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        performSegue(withIdentifier: "logOut", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToGame"{
            let gv = segue.destination as! GameViewController
            gv.namePlayer = namePlayer
            gv.timer = Date().timeIntervalSinceReferenceDate
        }
        else if segue.identifier == "Url"{
        let rpvc = segue.destination as! ResultViewController
        rpvc.urlPlayer = urlPlayer
        rpvc.namePlayer = namePlayer
        }
        else if segue.identifier == "goToEdit"{
        let evc = segue.destination as! EditViewController
        evc.namePlayer = namePlayer
        }
        
    }
    
 
    
    
}
