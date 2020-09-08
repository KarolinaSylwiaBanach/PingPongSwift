//
//  Result.swift
//  PingPongSwift
//
//  Created by Karolina Banach on 30/04/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

import Foundation

struct Result {
    var name = ""
    var date = ""
    var userScore = ""
    var enemyScore = ""
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
        self.userScore = dictionary["userScore"] as? String ?? ""
        self.enemyScore = dictionary["enemyScore"] as? String ?? ""
    }
}
