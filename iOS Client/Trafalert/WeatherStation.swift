//
//  WeatherStation.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit
import ReactiveKit

struct WeatherStation {
    
    let id: Int
    let name: String
    let roadNumber: Int
    let location: CLLocation
    
    var coordinate: CLLocationCoordinate2D {
        return self.location.coordinate
    }
    
    init(_ id: Int, _ name: String, _ roadNumber: Int, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        self.id = id
        self.name = name
        self.roadNumber = roadNumber
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}