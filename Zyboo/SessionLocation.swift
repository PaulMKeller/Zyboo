//
//  SessionLocation.swift
//  Zyboo
//
//  Created by Paul Keller on 7/2/18.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import Foundation
import MapKit

class SessionLocation: NSObject, MKAnnotation {
    var title: String?
    var locationName: String
    var discipline: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
