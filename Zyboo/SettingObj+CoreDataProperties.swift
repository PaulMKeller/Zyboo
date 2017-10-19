//
//  SettingObj+CoreDataProperties.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//
//

import Foundation
import CoreData


extension SettingObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingObj> {
        return NSFetchRequest<SettingObj>(entityName: "SettingObj")
    }

    @NSManaged public var settingGroup: String?
    @NSManaged public var settingName: String?

}
