//
//  ViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 21/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8.0
        loginButton.layer.cornerRadius = 8.0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.shouldPerformSegue(withIdentifier: "viewController", sender: self)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        performSegue(withIdentifier: "goToRegister", sender: self)
        
    }
    
}

