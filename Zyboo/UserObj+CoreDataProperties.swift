//
//  UserObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 23/4/18.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//
//

import Foundation
import CoreData


extension UserObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserObj> {
        return NSFetchRequest<UserObj>(entityName: "UserObj")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var nickName: String?
    @NSManaged public var contactNumber: String?

}
