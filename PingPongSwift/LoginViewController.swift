//
//  LoginViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 23/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginViewController: UIViewController {
    let URL = "http://karolinabanachios.cba.pl/login.php"
    let USER_NOT_EXIST = "User not exist"
    let USER_EXIST = "User exist"
    let ALL_RIGHT = "All right"
    
    @IBOutlet var nameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginButton: UIButton!
    var nameUser = ""
    var timer = Date.timeIntervalSinceReferenceDate;
    let file = "file.txt" , widok = "widok.txt", timeFileSave = "timeFileSave.txt", timeFileDownload = "timeFileDownload.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 8.0
        let timer2 = Date.timeIntervalSinceReferenceDate
        setView(view: "\((timer2-timer) * 1000)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.shouldPerformSegue(withIdentifier: "loginViewController", sender: self)
    }
    @IBAction func loginButton(_ sender: Any) {
        let nameString = nameText.text!
        let passwordString = passwordText.text!

        if(nameString.isEmpty){
            displayMassage(title: "Pole nazwa jest puste", message:"Wprowadź nazwę")
        }else if(passwordString.isEmpty){
            displayMassage(title: "Pole hasło jest puste", message: "Wprowadź hasło")
        }
        //creating parameters for the post request
        let parameters: Parameters=[
            "name" : nameString,
            "password" : passwordString
        ]
        
        //Sending http post request
        Alamofire.request(self.URL, method: .post, parameters: parameters).responseJSON
        {
            response in
            
            //getting the json value from the server
            if let result = response.result.value {
                
                //converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                //displaying the message in label
                let message = jsonData.value(forKey: "message") as! String
                //print(message)
                if(message==self.ALL_RIGHT){
                        let alert = UIAlertController(title: "Uwaga", message: "Nastąpiło poprawne logowanie do aplikacji", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Przejdź do menu", style: .default, handler: {_ in
                            self.performSegue(withIdentifier: "goToMenu", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    

                }else if(message==self.USER_EXIST){
                    
                    let alert = UIAlertController(title: "Uwaga", message: "Błędne hasło", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Popraw", style: .default, handler: {_ in}))
                    self.present(alert, animated: true, completion: nil)
                    
                }else if(message==self.USER_NOT_EXIST){
                    
                    let alert = UIAlertController(title: "Uwaga", message: "Użytkownik o podanej nazwie nie istnieje", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Popraw", style: .default, handler: {_ in}))
                    alert.addAction(UIAlertAction(title: "Zarejestruj się", style: .default, handler: {_ in
                        self.goToRegister()
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
        nameUser = nameString
        setName(name: nameString)
    }
    
    func displayMassage(title: String, message: String){

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Popraw", style: .default, handler: { _ in
            //Cancel Action
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backToRegister(_ sender: Any) {
        goToRegister()
    }
    
    private func goToRegister(){
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToMenu"{
        let mvc = segue.destination as! MenuViewController
        mvc.namePlayer = nameUser
        }
    }
    func setName(name: String){
        getName()
        let timer = Date().timeIntervalSinceReferenceDate
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        //writing
        do {
            try name.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        }
        let timer2 = Date().timeIntervalSinceReferenceDate
        setTimeSaveFile(fileSave: "\((timer2-timer) * 1000)")

    }
    
    func getName() -> String {
        var name = ""
        let timer = Date().timeIntervalSinceReferenceDate
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //reading
            do {
               name = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        let timer2 = Date().timeIntervalSinceReferenceDate
        setTimeDownloadFile(fileDownload:"\((timer2-timer) * 1000)")
        return name;
    }
    
    func setView(view: String){
        var view2 = getView()
        view2 = view2+"\n"+view
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(widok)
        //writing
        do {
            try view2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        }
        print("widok \(view2)")
    }
    
    func getView() -> String {
        var view = ""

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(widok)
            //reading
            do {
               view = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        return view;
    }
    
    func setTimeSaveFile(fileSave: String){
        var fileSave2 =  getTimeSaveFile()
        fileSave2 = fileSave2+"\n"+fileSave
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(timeFileSave)
        //writing
        do {
            try fileSave2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        }
        print("FileSave \(fileSave2)")
    }
    
    func setTimeDownloadFile(fileDownload: String){
        var fileDownload2 = getTimeDownloadFile()
        fileDownload2 = fileDownload2+"\n"+fileDownload
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(timeFileDownload)
        //writing
        do {
            try fileDownload2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        }
        print("FileDownload \(fileDownload2)")
    }
    
    func getTimeSaveFile() -> String  {
        var fileSave = ""

               if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                   let fileURL = dir.appendingPathComponent(timeFileSave)
                   //reading
                   do {
                      fileSave = try String(contentsOf: fileURL, encoding: .utf8)
                   }
                   catch {/* error handling here */}
               }
               return fileSave;
    }
    
    func getTimeDownloadFile() -> String {
        
        var fileDownload = ""

               if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                   let fileURL = dir.appendingPathComponent(timeFileDownload)
                   //reading
                   do {
                      fileDownload = try String(contentsOf: fileURL, encoding: .utf8)
                   }
                   catch {/* error handling here */}
               }
               return fileDownload;
    }
    
}
