//
//  passZybooItemTotal.swift
//  Zyboo
//
//  Created by Paul Keller on 18/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
import CoreData

protocol TriggerZybooItemSaveDelegate: class {
    func triggerItemSave()
}

protocol TriggerServiceChargeSaveDelegate: class {
    func triggerServiceChargeSave()
}

protocol PassBackDropPinDelegate: class {
    func passBackDropPin(dropPin: SessionLocation)
}

protocol TriggerSessionDetailShowDelegate: class {
    func triggerSessionDetailShow(cellSessionObj: NSManagedObject)
}

protocol TriggerSessionInfoShowDelegate: class {
    func triggerSessionInfoShow(cellSessionObj: NSManagedObject)
}
