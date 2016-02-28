//
//  WeatherStationGroup.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 24/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class WeatherStationGroup: Mappable {
    
    /*
    {
        "group_id" : 0,
        "stations" : [ {
            "id" : 1001,
            "tsaName" : "vt1_Nupuri_R"
            }, 
            {
            "id" : 1060,
            "tsaName" : "vt1_Nupuri_Opt"
            } 
        ],
        "coordinates" : {
            "x" : 24.59651311111374,
            "y" : 60.22790537188521
        },
        "road_number" : 1,
        "name" : "Tie 1 Espoo, Nupuri"
    },
    */

    var id = 0
    var stations = Array<WeatherStation>()
    var roadNumber = 0
    var name = ""
    var location: CLLocation?
    
    required init?(_ map: Map) {
        debugPrint("map \(map)")
    }
    
    func mapping(map: Map) {
        id = map["group_id"].currentValue as! Int
        roadNumber <- map["road_number"]
        name <- map["name"]
        location = CLLocation(latitude: map["coordinates.x"].currentValue as! Double,
            longitude: map["coordinates.y"].currentValue as! Double)
        
        if let stations = Mapper<WeatherStation>().mapArray(map["stations"]) {
            self.stations = stations
        }
        else {
            stations = Array<WeatherStation>()
        }
        debugPrint("id: \(id) Name: \(name)")
    }
}