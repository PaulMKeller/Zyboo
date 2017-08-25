//
//  Session.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Session : NSObject {
    var locationName: String = ""
    var locationLongitude: Double = 0.00
    var locationLatitude: Double = 0.00
    var sessionDate = Date()
    var sessionTotal: Double = 0.00
    var sessionItems = [ZybooItem]()
    
    override init(){}
    init(locationName: String, locationLongitude: Double, locationLatitude: Double, sessionDate: Date, sessionTotal: Double, sessionItems: [ZybooItem]) {
        self.locationName = locationName
        self.locationLongitude = locationLongitude
        self.locationLatitude = locationLatitude
        self.sessionDate = sessionDate
        self.sessionTotal = sessionTotal
        self.sessionItems = sessionItems
    }
    
    required init(coder aDecoder: NSCoder) {    }
    
    func encode(with _aCoder: NSCoder) {   }
}
