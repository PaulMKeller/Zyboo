//
//  CurrencyObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrencyObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyObj> {
        return NSFetchRequest<CurrencyObj>(entityName: "CurrencyObj")
    }

    @NSManaged public var currencyName: String?
    @NSManaged public var currencySymbol: String?
    @NSManaged public var currencyInitials: String?

}
