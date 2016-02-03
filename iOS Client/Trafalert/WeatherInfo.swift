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
/*
airTemperature = "-2";
averageWindSpeed = "0.3";
dewPoint = "-4.1";
humidity = 86;
maxWindSpeed = 2;
precipitation = "NO_PRECIPITATION";
precipitationIntensity = 0;
precipitationSum = 0;
precipitationType = "NO_PRECIPITATION";
roadCondition = DAMP;
roadSurfaceDewPointDifference = "1.2";
roadSurfaceTemperature = "-2.9";
stationId = 4065;
visibility = 20000;
windDirection = 23;
*/

class WeatherInfo: Mappable {
    var stationName = Observable("Unknown")
    var airTemp = Observable(19.1)
    var condition = Observable("Unknown")
    var roadTemp = Observable(0.0)
    var windSpeed = Observable(0)
    var windDirection = Observable(0)
    var precipitationIntensity = Observable(0)
    var visibility = Observable(0)
    
    init(){}
    
    required init?(_ map: Map) {
        
    }
    
    func updateWith(info: WeatherInfo) {
        self.stationName.value = info.stationName.value
        self.airTemp.value = info.airTemp.value
        self.condition.value = info.condition.value
        self.roadTemp.value = info.roadTemp.value
        self.windSpeed.value = info.windSpeed.value
        self.windDirection.value = info.windDirection.value
        self.precipitationIntensity.value = info.precipitationIntensity.value
        self.visibility.value = info.visibility.value
    }
    
    
    func mapping(map: Map) {
        self.airTemp.value <- map["airTemperature"]
        self.condition.value <- map["roadCondition"]
        self.roadTemp.value <- map["roadSurfaceTemperature"]
        self.windSpeed.value <- map["averageWindSpeed"]
        self.windDirection.value <- map["windDirection"]
        self.precipitationIntensity.value <- map["precipitationIntensity"]
        self.visibility.value <- map["visibility"]
    }
}
