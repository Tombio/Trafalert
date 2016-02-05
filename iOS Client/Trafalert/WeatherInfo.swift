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
{
    stationId = 4065;
    warnings =     (
        {
            beginTime =             {
                chronology =                 {
                    calendarType = iso8601;
                    id = ISO;
                };
                dayOfMonth = 4;
                dayOfWeek = THURSDAY;
                dayOfYear = 35;
                hour = 18;
                minute = 52;
                month = FEBRUARY;
                monthValue = 2;
                nano = 263000000;
                second = 37;
                year = 2016;
            };
            roadDewPointDifference = "-0.5";
            roadSurfaceTemperature = "-1.4";
            version = 204;
            warningType = "BLACK_ICE";
        }
    );
    weatherData =     {
        airTemperature = "-0.8";
        averageWindSpeed = "2.4";
        dewPoint = "-1.1";
        humidity = 98;
        maxWindSpeed = "5.6";
        precipitation = "NO_PRECIPITATION";
        precipitationIntensity = 0;
        precipitationSum = "0.4";
        precipitationType = "NO_PRECIPITATION";
        roadCondition = DAMP;
        roadSurfaceDewPointDifference = "-0.3";
        roadSurfaceTemperature = "-1.4";
        stationId = 4065;
        visibility = 20000;
        windDirection = 271;
    };
}
*/
class WeatherStationData: Mappable {
    var stationId: Int?
    var info: WeatherInfo?
    var warnings: [Warning]?
    
    init(){}
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        stationId <- map["stationId"]
        info <- map["weatherData"]
        warnings = Mapper<Warning>().mapArray(map["warnings"].value())
    }
}

class Warning: Mappable {
    
    enum WarningType: String {
        case NONE = ""
        case BLACK_ICE = "Mustaa jäätä"
        case STRONG_WIND = "Voimakas tuuli"
        case STRONG_WIND_GUSTS = "Voimakas tuuli puuskissa"
        case POOR_VISIBILITY = "Huono näkyvyys"
        case SLIPPERY_ROAD = "Liukas tie"
        case HEAVY_RAIN = "Rankkasade"
    }
    
    var version = Observable(0)
    var warningType = Observable(WarningType.NONE)
    
    init(){}
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        version.value <- map["version"]
        warningType.value <- map["warningType"]
    }
    
    var hashValue: Int {
        return version.value.hashValue
    }
}

func ==(lhs: Warning, rhs: Warning) -> Bool {
    return lhs.version.value == rhs.version.value
}

class WeatherInfo: Mappable {
    
    enum RoadCondition: String {
        case NONE = ""
        case SENSOR_ERROR = "Mittausvirhe"
        case DRY = "Kuiva"
        case DAMP = "Kostea"
        case WET = "Märkä"
        case WET_WITH_SALT = "Märkä ja suolattu"
        case FROST = "Kuuraa"
        case SNOW = "Lunta"
        case ICE = "Jäätä"
        case LIKELY_WET_WITH_SALT = "Suolattu"
    }
    
    var stationName = Observable("Unknown")
    var airTemp = Observable(19.1)
    var condition = Observable(RoadCondition.NONE)
    var roadTemp = Observable(0.0)
    var windSpeed = Observable(0)
    var windDirection = Observable(0)
    var precipitationIntensity = Observable(0)
    var visibility = Observable(0)
    var roadSurfaceDewPointDifference = Observable(0.0)
    var dewPoint = Observable(0.0)
    
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
        self.roadSurfaceDewPointDifference.value = info.roadSurfaceDewPointDifference.value
        self.dewPoint.value = info.dewPoint.value
    }
    
    
    func mapping(map: Map) {
        self.airTemp.value <- map["airTemperature"]
        self.condition.value <- map["roadCondition"]
        self.roadTemp.value <- map["roadSurfaceTemperature"]
        self.windSpeed.value <- map["averageWindSpeed"]
        self.windDirection.value <- map["windDirection"]
        self.precipitationIntensity.value <- map["precipitationIntensity"]
        self.visibility.value <- map["visibility"]
        self.roadSurfaceDewPointDifference.value <- map["roadSurfaceDewPointDifference"]
        self.dewPoint.value <- map["dewPoint"]
    }
}
