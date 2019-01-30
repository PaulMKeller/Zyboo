//
//  HappyHourObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 30/1/19.
//  Copyright © 2019 PlanetKGames. All rights reserved.
//
//

import Foundation
import CoreData


extension HappyHourObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HappyHourObj> {
        return NSFetchRequest<HappyHourObj>(entityName: "HappyHourObj")
    }

    @NSManaged public var barName: String?
    @NSManaged public var websiteAddress: String?
    @NSManaged public var happyHourDetails: String?

}
