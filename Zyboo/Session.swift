//
//  Session.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Session {
    var sessionID: Int64 = 0
    var locationName: String = ""
    var sessionDate: String = ""
    
    init(){}
    init(sessionID: Int64, locationName: String, sessionDate: String) {
        self.sessionID = sessionID
        self.locationName = locationName
        self.sessionDate = sessionDate
    }
}
