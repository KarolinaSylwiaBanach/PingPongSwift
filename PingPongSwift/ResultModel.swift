//
//  ResultModel.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 04/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol ResultModelDelegate {
    func itemsDownloaded(result:[Result])
    
}
class ResultModel:NSObject{
    var URLRESULT = "http://karolinabanachios.cba.pl/getResult.php"
    var delegate : ResultModelDelegate?
    var namePlayer = ""
    let downloadDB = "downloadDB.txt"
    
    init(urlPlayer:Bool, namePlayer:String) {
        if(urlPlayer){
            self.URLRESULT = "http://karolinabanachios.cba.pl/getPlayerResult.php"
        }else{
            self.URLRESULT = "http://karolinabanachios.cba.pl/getResult.php"
        }
        self.namePlayer = namePlayer
    }
    
    func getItems(){
        var resultArray = [Result]()
        let parameters: Parameters=[
            "name" : namePlayer
        ]
        let timer = Date().timeIntervalSinceReferenceDate
        //Sending http post request
        Alamofire.request(self.URLRESULT, method: .post, parameters: parameters).responseJSON
        {
            response in

            //getting the json value from the server
            if let result = response.result.value {
                guard let jsonArray = result as? [[String: Any]] else {
                      return
                }
                for dic in jsonArray{
                    resultArray.append(Result(dic))
                }
                self.delegate?.itemsDownloaded(result: resultArray)
            }
            
       }
        let timer2 =  Date().timeIntervalSinceReferenceDate
        setTimeDownloadDB(downloadDB:"\((timer2-timer) * 1000)")
    }
    
    func setTimeDownloadDB(downloadDB: String){
        
        var downloadDB2 = getTimeDownloadDB()
        downloadDB2 = downloadDB2+"\n"+downloadDB
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(self.downloadDB)
        //writing
        do {
            try downloadDB2.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {}
        }
        print("DownloadDB \(downloadDB2)")
        
    }
    
    func getTimeDownloadDB() -> String  {
        var downloadDB = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(self.downloadDB)
           //reading
           do {
              downloadDB = try String(contentsOf: fileURL, encoding: .utf8)
           }
           catch {}
       }
       return downloadDB;
    }
    
    
}

