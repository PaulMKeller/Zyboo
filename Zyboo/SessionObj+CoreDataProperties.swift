//
//  SessionObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 14/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
import CoreData


extension SessionObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionObj> {
        return NSFetchRequest<SessionObj>(entityName: "SessionObj")
    }

    @NSManaged public var locationName: String?
    @NSManaged public var sessionDate: NSDate?
    @NSManaged public var zybooItems: NSMutableArray?

}

// MARK: Generated accessors for zybooItems
extension SessionObj {

    @objc(addZybooItemsObject:)
    @NSManaged public func addToZybooItems(_ value: ZybooItemObj)

    @objc(removeZybooItemsObject:)
    @NSManaged public func removeFromZybooItems(_ value: ZybooItemObj)

    @objc(addZybooItems:)
    @NSManaged public func addToZybooItems(_ values: NSMutableArray)

    @objc(removeZybooItems:)
    @NSManaged public func removeFromZybooItems(_ values: NSMutableArray)

}
