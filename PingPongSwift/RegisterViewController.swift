//
//  RegisterViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 21/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Darwin

class RegisterViewController: UIViewController {
    
    let URL_REGISTER = "http://karolinabanachios.cba.pl/register.php"
    let USER_CREATED = "User created successfully"
    let USER_EXIST = "User already exist"
    
    
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var backToLogIn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.shouldPerformSegue(withIdentifier: "registerView", sender: self)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        let nameString = nameText.text!
        let emailString = emailText.text!
        let passwordString = passwordText.text!
        let password2String = password2Text.text!
        // check for empty
        if(nameString.isEmpty){
            displayMassage(title: "Pole nazwa jest puste", message:"Wprowadź nazwę")
        }else if(emailString.isEmpty){
            displayMassage(title: "Pole email jest puste", message:"Wprowadź email")
        }else if(password2String.isEmpty){
            displayMassage(title: "Pole powtórz hasło jest puste", message:"Powtórz hasło")
        }else if(passwordString.isEmpty){
            displayMassage(title: "Pole hasło jest puste", message:"Wprowadź hasło")
        }else if(passwordString.count < 4 || passwordString.count > 50 ){
            displayMassage(title: "Hasło jest nieodpowiedniej długości" ,message: "Wprowadź hasło o długości od 4 do 50 znaków")
        }else if(nameString.count < 4 || nameString.count > 20 ){
            displayMassage(title: "Nazwa jest nieodpowiedniej długości" ,message: "Wprowadź nazwę o długości od 4 do 20 znaków")
        }
        // check if email is valid
        else if(!isValidEmail(emailString)){
             displayMassage(title: "Email jest niepoprawny" ,message: "Wprowadź poprawny email")
        }
        // check if password is the same
        else if(passwordString != password2String){
            displayMassage(title: "Hasła nie są takie same" ,message: "Wprowadź takie hasła")
        }
        
        
        //creating parameters for the post request
        let parameters: Parameters=[
            "name" : nameString ,
            "email" : emailString,
            "password" : passwordString
        ]
        
        //Sending http post request
        Alamofire.request(self.URL_REGISTER, method: .post, parameters: parameters).responseJSON
        {
            response in
            
            //getting the json value from the server
            if let result = response.result.value {
                
                //converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                //displaying the message in label
                let message = jsonData.value(forKey: "message") as! String
                //print(message)
                if(message==self.USER_CREATED){
                    let alert = UIAlertController(title: "Uwaga", message: "Nastąpiła poprawna rejestracja", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Zaloguj się", style: .default, handler: {_ in
                         self.performSegue(withIdentifier: "goToLogin", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                   
                    
                }else if(message==self.USER_EXIST){
                    let alert = UIAlertController(title: "Uwaga", message: "Użytkownik o danej nazwie lub emailu już istnieje", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Popraw", style: .default, handler: {_ in}))
                    alert.addAction(UIAlertAction(title: "Zaloguj się", style: .default, handler: {_ in
                        self.performSegue(withIdentifier: "goToLogin", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Uwaga", message: "Nieoczekiwany błąd sieci, spróbuj ponownie później", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Wyjdź", style: .default, handler: {_ in
                        //Action
                        exit(0)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func displayMassage(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Popraw", style: .default, handler: { _ in
            //Cancel Action
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToLogin"{
        let lvc = segue.destination as! LoginViewController
            
            lvc.timer = Date().timeIntervalSinceReferenceDate 
        
        }
    }
    
}

