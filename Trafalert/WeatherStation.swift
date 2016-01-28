//
//  WeatherStation.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit

class WeatherStation: NSObject, MKAnnotation {
    
    let name: String
    let roadNumber: Int
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    // MARK: MKAnnotation impl
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return "Road \(self.roadNumber)"
    }
    
    init(_ name: String, _ roadNumber: Int, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        self.name = name
        self.roadNumber = roadNumber
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
}