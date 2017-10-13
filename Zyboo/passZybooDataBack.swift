//
//  passZybooItemTotal.swift
//  Zyboo
//
//  Created by Paul Keller on 18/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
import CoreData

protocol ZybooItemTotalPassBackDelegate: class {
    func passItemDataBack()
}

protocol ZybooSessionPassBackDelegate: class {
    func passSessionDataBack(session: NSManagedObject)
}
