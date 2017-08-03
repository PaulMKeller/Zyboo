//
//  passZybooItemTotal.swift
//  Zyboo
//
//  Created by Paul Keller on 18/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

protocol ZybooItemTotalPassBackDelegate: class {
    func passItemDataBack(cellZybooItem: ZybooItem)
}

protocol ZybooSessionPassBackDelegate: class {
    func passSessionDataBack(sessionObj: Session)
}