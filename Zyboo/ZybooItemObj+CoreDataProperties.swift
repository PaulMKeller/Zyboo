//
//  ZybooItemObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 14/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
import CoreData


extension ZybooItemObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZybooItemObj> {
        return NSFetchRequest<ZybooItemObj>(entityName: "ZybooItemObj")
    }

    @NSManaged public var itemCount: Int32
    @NSManaged public var itemName: String?
    @NSManaged public var unitCost: Double
    @NSManaged public var sessions: SessionObj?

}
