//
//  CalculationFunctions.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class calculationFunctions {
    init() {}
    func calculateRunningTotal (thisSessionObj: SessionObj) -> String {
        var runningTotal:Double = 0
        
        let thisSession = thisSessionObj
        let currentItems = thisSession.zybooItems!
        
        for sessionItem in currentItems {
            let thisItem = sessionItem as! ZybooItemObj
            
            runningTotal = runningTotal + (Double(thisItem.itemCount) * thisItem.unitCost)
        }
        
        return "Total: $" + String(Int(runningTotal))
    }
}
