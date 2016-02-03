//
//  Extension.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 02/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import CoreLocation

extension WeatherStation {
    func distanceFrom(location: CLLocation) -> Double {
        return self.location.distanceFromLocation(location)
    }
}

extension WeatherStationList {
    
    static func nearestStation(location: CLLocation) -> WeatherStation {
        return sortedStations(location).first!
    }
    
    static func sortedStations(location: CLLocation) -> [WeatherStation] {
        return WeatherStationList.weatherStations.sort({
            return $0.0.distanceFrom(location) < $0.1.distanceFrom(location)
        })
    }
}