//
//  CalculationFunctions.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class calculationFunctions {
    init() {}
    func calculateRunningTotal (thisSessionObj: SessionObj, serviceCharges: [NSManagedObject]) -> String {
        var runningTotal:Decimal = 0
        
        let currentItems = thisSessionObj.zybooItems!
        
        for sessionItem in currentItems {
            let thisItem = sessionItem as! ZybooItemObj
            
            runningTotal = runningTotal + (Decimal(thisItem.itemCount) * Decimal(thisItem.unitCost))
        }
        
        if thisSessionObj.value(forKey: "applyServiceCharge") as! Bool {
            for charge in serviceCharges {
                let thisCharge = charge as! ServiceChargeObj
                let chargeTotal = runningTotal * Decimal(thisCharge.percentageCharge / 100)
                print(thisCharge.percentageCharge)
                print(Decimal(thisCharge.percentageCharge / 100))
                print(chargeTotal)
                runningTotal = runningTotal + chargeTotal
            }
        }
        
        return "Total: $" + String(runningTotal)
    }
}
