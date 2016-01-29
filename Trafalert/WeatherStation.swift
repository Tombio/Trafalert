//
//  WeatherStation.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit

struct WeatherStation {
    
    let id: Int
    let name: String
    let roadNumber: Int
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(_ id: Int, _ name: String, _ roadNumber: Int, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        self.id = id
        self.name = name
        self.roadNumber = roadNumber
        self.latitude = latitude
        self.longitude = longitude
    }
}