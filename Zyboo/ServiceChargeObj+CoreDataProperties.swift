//
//  ServiceChargeObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//
//

import Foundation
import CoreData


extension ServiceChargeObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceChargeObj> {
        return NSFetchRequest<ServiceChargeObj>(entityName: "ServiceChargeObj")
    }

    @NSManaged public var chargeName: String?
    @NSManaged public var percentageCharge: Int16
    @NSManaged public var isOn: Bool
    @NSManaged public var applicationOrder: Int16

}
