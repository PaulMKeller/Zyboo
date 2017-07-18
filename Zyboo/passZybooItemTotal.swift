//
//  passZybooItemTotal.swift
//  Zyboo
//
//  Created by Paul Keller on 18/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

protocol ZybooItemTotalPassBackDelegate: class {
    func passTotalDataBack(startingTotal: Double, newTotal: Double)
}
