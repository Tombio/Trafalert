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
    var info = WeatherInfo()
    var warnings = ObservableCollection(Array<Warning>())
    
    init(){}
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        stationId <- map["stationId"]
        info <- map["weatherData"]
        warnings <- map["warnings"]//Mapper<Warning>().mapArray(map["warnings"].value())
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
    
    enum PrecipitationType: String {
        case UNKNOWN = "UNKNOWN"
        case NO_PRECIPITATION = "NO_PRECIPITATION"
        case WEAK_PRECIPITATION_UNDEFINED = "WEAK_PRECIPITATION_UNDEFINED"
        case WEAK_WATER = "WEAK_WATER"
        case WATER = "WATER"
        case SNOW = "SNOW"
        case WET_SLEET = "WET_SLEET"
        case SLEET = "SLEET"
        case HAIL = "HAIL"
        case ICE_CRYSTAL = "ICE_CRYSTAL"
        case SNOW_PARTICLES = "SNOW_PARTICLES"
        case SNOW_HAIL = "SNOW_HAIL"
        case FREEZING_WEAK_WATER = "FREEZING_WEAK_WATER"
        case FREEZING_WATER = "FREEZING_WATER"
        
        func humanReadable() -> String {
            switch(self) {
                case .UNKNOWN: return ""
                case .NO_PRECIPITATION: return "Pouta"
                case .WEAK_PRECIPITATION_UNDEFINED: return "Heikkoa sadetta"
                case .WEAK_WATER: return "Heikkoa vesisadetta"
                case .WATER: return "Vesisadetta"
                case .SNOW: return "Lumisadetta"
                case .WET_SLEET: return "Märkää lunta"
                case .SLEET: return "Räntäsadetta"
                case .HAIL: return "Rakeita"
                case .ICE_CRYSTAL: return "Jääkiteitä"
                case .SNOW_PARTICLES: return "Lumikiteiteitä"
                case .SNOW_HAIL: return "Lunta ja rakeita"
                case .FREEZING_WEAK_WATER: return "Jäätävää tihkua"
                case .FREEZING_WATER: return "Alijäähtynyttä vettä"
            }
        }
    }
    
    enum RoadCondition: String {
        case NONE = ""
        case SENSOR_ERROR = "SENSOR_ERROR"
        case DRY = "DRY"
        case DAMP = "DAMP"
        case WET = "WET"
        case WET_WITH_SALT = "WET_WITH_SALT"
        case FROST = "FROST"
        case SNOW = "SNOW"
        case ICE = "ICE"
        case LIKELY_WET_WITH_SALT = "LIKELY_WET_WITH_SALT"
        
        func humanReadable() -> String {
            switch(self) {
                case .SENSOR_ERROR: return "Mittausvirhe"
                case .DRY: return "Kuivaa"
                case .DAMP: return "Kosteaa"
                case .WET: return "Märkää"
                case .WET_WITH_SALT: return "Märkä ja suolattu"
                case .FROST: return "Kuuraa"
                case .SNOW: return "Lunta"
                case .ICE: return "Jäätä"
                case .LIKELY_WET_WITH_SALT: return "Suolattu"
                default: return ""
            }
        }
    }
    
    var stationName = Observable("Unknown")
    var airTemp = Observable(19.1)
    var precipitationType = Observable(PrecipitationType.UNKNOWN)
    var roadTemp = Observable(0.0)
    var windSpeed = Observable(0)
    var windDirection = Observable(0)
    var precipitationIntensity = Observable(0)
    var visibility = Observable(0)
    var roadSurfaceDewPointDifference = Observable(0.0)
    var roadSurfaceCondition = Observable(RoadCondition.NONE)
    var dewPoint = Observable(0.0)
    
    let transform = TransformOf<PrecipitationType, String>(fromJSON: { (value: String?) -> PrecipitationType? in
            if let _ = value {
                return PrecipitationType(rawValue: value!)
            }
            else {
                return PrecipitationType.UNKNOWN
            }
        }, toJSON: { (value: PrecipitationType?) -> String? in
            // transform value from Int? to String?
            if let value = value {
                return String(value)
            }
            return nil
    })
    
    init(){}
    
    required init?(_ map: Map) {
        
    }
    
    func updateWith(info: WeatherInfo) {
        self.stationName.value = info.stationName.value
        self.airTemp.value = info.airTemp.value
        self.precipitationType.value = info.precipitationType.value
        self.roadTemp.value = info.roadTemp.value
        self.windSpeed.value = info.windSpeed.value
        self.windDirection.value = info.windDirection.value
        self.precipitationIntensity.value = info.precipitationIntensity.value
        self.visibility.value = info.visibility.value
        self.roadSurfaceDewPointDifference.value = info.roadSurfaceDewPointDifference.value
        self.dewPoint.value = info.dewPoint.value
        self.roadSurfaceCondition.value = info.roadSurfaceCondition.value
        debugPrint(self.roadSurfaceCondition.value)
    }
    
    
    func mapping(map: Map) {
        self.airTemp.value <- map["airTemperature"]
        self.precipitationType.value <- (map["precipitation"], transform) // More accurate than precipitationType
        self.roadTemp.value <- map["roadSurfaceTemperature"]
        self.windSpeed.value <- map["averageWindSpeed"]
        self.windDirection.value <- map["windDirection"]
        self.precipitationIntensity.value <- map["precipitationIntensity"]
        self.visibility.value <- map["visibility"]
        self.roadSurfaceDewPointDifference.value <- map["roadSurfaceDewPointDifference"]
        self.dewPoint.value <- map["dewPoint"]
        self.roadSurfaceCondition.value <- (map["roadCondition"], EnumTransform<RoadCondition>())
    }
}
