//
//  Extension.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 02/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

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

extension Array where Element: Warning {
    func maxVersion() -> Int? {
        let sorted = sort { $0.version.value > $1.version.value }
        return sorted.first?.version.value
    }
}

extension Array where Element: WeatherStationData {
    func getWarnings(id: Int) -> [Warning] {
        for ws in self {
            if ws.stationId! == id {
                return ws.warnings.collection
            }
        }
        return Array<Warning>()
    }
}

typealias MappableInt = Int
extension MappableInt: Mappable {
    public init?(_ map: Map) {
        self = map.currentValue as! Int
    }
    
    public mutating func mapping(map: Map) {
        self <- map
    }
}

extension NSCalendar {
    
    enum Season {
        case Summer
        case Winter
        case Fall
        case Spring
    }
    
    enum TimeOfDay {
        case Morning
        case Day
        case Evening
        case Night
    }
    
    func season() -> Season {
        let components = self.components([.Day , .Month , .Year], fromDate: NSDate())
        switch components.month {
            case 1..<4 : return .Winter
            case 4..<9 : return .Summer
            default: return .Winter
        }
    }
    
    func timeOfDay() -> TimeOfDay {
        let components = self.components([.Hour], fromDate: NSDate())
        switch components.hour {
            case 0..<8 : return .Night
            case 8..<19 : return .Day
            default: return .Night
        }
    }
}