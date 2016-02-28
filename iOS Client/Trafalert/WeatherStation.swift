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
import ObjectMapper

class WeatherStation: Mappable {
    
    var id = 0 // id
    var name = "" // nameFi
    var roadNumber = 0 // roadNumber
    var location = CLLocation(latitude: 0, longitude: 0) // coordinateNode (x,y)
    
    required init?(_ map: Map) {

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        roadNumber <- map["roadNumber"]
        let x = map["coordinate.x"].currentValue as! Double
        let y = map["coordinate.y"].currentValue as! Double
        location = CLLocation(latitude: x, longitude: y)
    }

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