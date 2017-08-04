//
//  Session.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Session : NSObject {
    var sessionID: Int64 = 0
    var locationName: String = ""
    var sessionDate = Date()
    var sessionTotal: Double = 0.00
    var sessionItems = [ZybooItem]()
    
    override init(){}
    init(sessionID: Int64, locationName: String, sessionDate: Date, sessionTotal: Double, sessionItems: [ZybooItem]) {
        self.sessionID = sessionID
        self.locationName = locationName
        self.sessionDate = sessionDate
        self.sessionTotal = sessionTotal
        self.sessionItems = sessionItems
    }
    
    required init(coder aDecoder: NSCoder) {    }
    
    func encode(with _aCoder: NSCoder) {   }
}
