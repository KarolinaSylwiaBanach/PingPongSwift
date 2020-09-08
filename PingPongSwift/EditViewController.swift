//
//  EditViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 13/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Darwin

class EditViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    let URL_REGISTER = "http://karolinabanachios.cba.pl/edit.php"
    let USER_CREATED = "User created successfully"
    let USER_EXIST = "User already exist"
    var namePlayer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 8.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.shouldPerformSegue(withIdentifier: "registerView", sender: self)
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        
        let emailString = emailText.text!
        let passwordString = passwordText.text!
        let password2String = password2Text.text!

        if(!emailString.isEmpty){
        if(!isValidEmail(emailString)){
             displayMassage(title: "Email jest niepoprawny" ,message: "Wprowadź poprawny email")
        }}
        // check if password is the same
        else if(passwordString != password2String){
            displayMassage(title: "Hasła nie są takie same" ,message: "Wprowadź takie hasła")
        }
            //creating parameters for the post request
            var parameters: Parameters = ["name": namePlayer]
            if(emailString.isEmpty && !passwordString.isEmpty){
                parameters=[
                    "name" : namePlayer ,
                    "password" : passwordString
                ]

            }else if(!emailString.isEmpty && passwordString.isEmpty){
                parameters=[
                    "name" : namePlayer ,
                    "email" : emailString
                ]
            }else if(!emailString.isEmpty && !passwordString.isEmpty){
                parameters=[
                    "name" : namePlayer ,
                    "email" : emailString,
                    "password" : passwordString
                ]
            }else{
                performSegue(withIdentifier: "goToMenu", sender: self)
            }
                
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
                   // print(message)
                    if(message==self.USER_CREATED){
                        let alert = UIAlertController(title: "Uwaga", message: "Nastąpiła poprawna edycja danych", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Przejdź do menu", style: .default, handler: {_ in
                             self.performSegue(withIdentifier: "goToMenu", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                           
                    }else if(message==self.USER_EXIST){
                        let alert = UIAlertController(title: "Uwaga", message: "Użytkownik o danym emailu już istnieje", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Popraw", style: .default, handler: {_ in}))
                        alert.addAction(UIAlertAction(title: "Wróć do menu", style: .default, handler: {_ in
                            self.performSegue(withIdentifier: "goToMenu", sender: self)
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
    
    
    @IBAction func goToMenu(_ sender: Any) {
        performSegue(withIdentifier: "goToMenu", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToMenu"{
                   let mvc = segue.destination as! MenuViewController
                   mvc.namePlayer = namePlayer
        }
    }
        

}
