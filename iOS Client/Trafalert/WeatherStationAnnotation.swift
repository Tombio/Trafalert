//
//  WeatherStationOverlay.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 29/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit

class WeatherStationAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    
    var stationName: String
    var active: Bool
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, stationName: String, active: Bool, coord: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.stationName = stationName
        self.active = active
        self.coordinate = coord
    }
    
    /*
    class func createOverlay(coord: CLLocationCoordinate2D, _ radius: CLLocationDistance, _ name: String) -> MKCircle {
        let circle = WeatherStationOverlay(centerCoordinate: coord, radius: radius)
        circle.stationName = name
        return circle
    }*/
}