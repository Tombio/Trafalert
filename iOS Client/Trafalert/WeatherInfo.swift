//
//  WeatherInfo.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 01/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import ReactiveKit
import ObjectMapper

class WeatherInfo: Mappable {
    var stationName = Observable("Unknown")
    var airTemp = Observable(19.1)
    var condition = Observable("Unknown")
    var roadTemp = Observable(0.0)
    var windSpeed = Observable(0.0)
    var windDirection = Observable(0)
    
    init(){}
    
    required init?(_ map: Map) {
        
    }
    
    func updateWith(info: WeatherInfo) {
        self.airTemp.value = info.airTemp.value
        self.condition.value = info.condition.value
        self.roadTemp.value = info.roadTemp.value
        self.windSpeed.value = info.windSpeed.value
        self.windDirection.value = info.windDirection.value
    }
    
    
    func mapping(map: Map) {
        self.airTemp.value <- map["airTemperature"]
        self.condition.value <- map["roadCondition"]
    }
}
