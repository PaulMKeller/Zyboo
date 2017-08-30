//
//  ZybooItem.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class ZybooItem : NSObject {
    var itemName: String = ""
    var itemCount: Int32 = 0
    var unitCost: Double = 0.0
    var favouriteItem: Bool = false
    
    override init(){
    }
    
    init(itemName: String, itemCount: Int32, unitCost: Double, favouriteItem: Bool){
        self.itemName = itemName
        self.itemCount = itemCount
        self.unitCost = unitCost
        self.favouriteItem = favouriteItem
    }
    
    required init(coder aDecoder: NSCoder) {    }
    
    func encode(with _aCoder: NSCoder) {   }
}
