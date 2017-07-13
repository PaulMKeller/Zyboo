//
//  ZybooItem.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class ZybooItem {
    var itemID: Int32 = 0
    var itemName: String = ""
    var itemCount: Int32 = 0
    var unitCost: Double = 0.0
    
    init(){
    }
    
    init(itemID: Int32, itemName: String, itemCount: Int32, unitCost: Double){
        self.itemID = itemID
        self.itemName = itemName
        self.itemCount = itemCount
        self.unitCost = unitCost
    }
}
