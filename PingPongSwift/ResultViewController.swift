//
//  ResultViewController.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 21/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ResultViewController: UIViewController, ResultModelDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var result = [Result]()
    var resultModel = ResultModel(urlPlayer: false, namePlayer: "")
    var urlPlayer = false
    var namePlayer = ""
    var resultArray = [Result]()
      
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backToMenuButton.layer.cornerRadius = 8.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        resultModel = ResultModel(urlPlayer: urlPlayer, namePlayer: namePlayer)
        resultModel.getItems()
        resultModel.delegate = self
        
        if(result.count==0){
            let alert = UIAlertController(title: "Uwaga", message: "Użytkownik nie posiada wyników", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Wróć do menu", style: .default, handler: {_ in
                self.performSegue(withIdentifier: "goToMenu", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.shouldPerformSegue(withIdentifier: "resultViewController", sender: self)
    }
    
    @IBAction func backToMenuButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMenu", sender: self)
    }
    
    func itemsDownloaded(result: [Result]) {
        self.result = result
        if(result.count==0){
            let alert = UIAlertController(title: "Uwaga", message: "Użytkownik nie posiada wyników", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Wróć do menu", style: .default, handler: {_ in
                self.performSegue(withIdentifier: "goToMenu", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.font = UIFont(name:"Avenir Book ", size:20)
        cell.textLabel?.text = result[indexPath.row].date + "   " + result[indexPath.row].userScore + "   " + result[indexPath.row].enemyScore + "   " + result[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToMenu"{
            let mvc = segue.destination as! MenuViewController
            mvc.namePlayer = namePlayer
        }
        
        
    }
}
