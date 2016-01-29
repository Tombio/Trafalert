//
//  WeatherStationOverlay.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 29/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit

class WeatherStationOverlay: MKCircle {
    
    var stationName: String?
    
    class func createOverlay(coord: CLLocationCoordinate2D, _ radius: CLLocationDistance, _ name: String) -> MKCircle {
        let circle = WeatherStationOverlay(centerCoordinate: coord, radius: radius)
        circle.stationName = name
        return circle
    }
}