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
import UIKit

class WeatherStationData: Mappable {
    var stationId: Int?
    var info = WeatherInfo()
    let warnings = ObservableCollection(Array<Warning>())
    
    init(){}
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        stationId <- map["stationId"]
        info <- map["weatherData"]
        if let warn = Mapper<Warning>().mapArray(map["warnings"].currentValue) {
            debugPrint("Warnings found")
            warnings.replace(warn)
        }
        else {
            debugPrint("No warnings")
            warnings.replace(Array<Warning>())
        }
        debugPrint(warnings.collection)
    }
}

class Warning: Mappable {
    
    enum WarningType: String {
        case NONE
        case BLACK_ICE
        case STRONG_WIND
        case STRONG_WIND_GUSTS
        case POOR_VISIBILITY
        case SLIPPERY_ROAD
        case HEAVY_RAIN
        
        func humanReadable() -> String {
            switch(self){
            case .NONE: return ""
            case .BLACK_ICE: return "Mustaa jäätä"
            case .STRONG_WIND: return "Voimakas tuuli"
            case .STRONG_WIND_GUSTS: return "Voimakas tuuli puuskissa"
            case .POOR_VISIBILITY: return "Huono näkyvyys"
            case .SLIPPERY_ROAD: return "Liukas tie"
            case .HEAVY_RAIN: return "Rankkasade"
            }
        }

    }
    
    var station: Int?
    var version = Observable(0)
    var warningType = Observable(WarningType.NONE)
    
    init(){}
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        station <- map["stationId"]
        version.value <- map["version"]
        warningType.value <- map["warningType"]
    }
}

class WeatherInfo: Mappable {
    
    enum PrecipitationType: String {
        case UNKNOWN = "UNKNOWN"
        case NO_PRECIPITATION = "NO_PRECIPITATION"
        case WEAK_PRECIPITATION_UNDEFINED = "WEAK_PRECIPITATION_UNDEFINED"
        case WEAK_WATER = "WEAK_WATER"
        case WATER = "WATER"
        case WEAK_SNOW = "WEAK_SNOW"
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
                case .WEAK_SNOW: return "Heikkoa lumisadetta"
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
        
        func skyBackgroundImage() -> UIImage {
            let timeofDay = NSCalendar.currentCalendar().timeOfDay()
            
            debugPrint(timeofDay)
            switch(self) {
                case .UNKNOWN: return timeofDay == NSCalendar.TimeOfDay.Day ? UI.clearDay : UI.clearNight
                case .NO_PRECIPITATION: return timeofDay == NSCalendar.TimeOfDay.Day ? UI.clearDay : UI.clearNight
                case .WEAK_SNOW: return timeofDay == NSCalendar.TimeOfDay.Day ? UI.clearDay : UI.clearNight
                case .WEAK_WATER: return timeofDay == NSCalendar.TimeOfDay.Day ? UI.clearDay : UI.clearNight
                default: return UI.rainBackground
            }
        }
        
        func rainImage() -> UIImage? {
            switch(self) {
            case .UNKNOWN: return nil
            case .NO_PRECIPITATION: return nil
            case .WEAK_PRECIPITATION_UNDEFINED: return UI.rain
            case .WEAK_WATER: return UI.rain
            case .WATER: return UI.rain
            case .WEAK_SNOW: return UI.snow
            case .SNOW: return UI.snow
            case .WET_SLEET: return UI.rain
            case .SLEET: return UI.snow
            case .HAIL: return UI.snow
            case .ICE_CRYSTAL: return UI.snow
            case .SNOW_PARTICLES: return UI.snow
            case .SNOW_HAIL: return UI.snow
            case .FREEZING_WEAK_WATER: return UI.rain
            case .FREEZING_WATER: return UI.rain
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
        
        func roadImage() -> UIImage {
            let season = NSCalendar.currentCalendar().season()
            switch(self){
            case .DRY: return season == .Summer ? UI.summerDry : UI.winterDry
            case .DAMP: return season == .Summer ? UI.summerWet : UI.winterWet
            case .WET: return season == .Summer ? UI.summerWet : UI.winterWet
            case .WET_WITH_SALT: return UI.winterWet;
            case .FROST: return season == .Summer ? UI.summerWet : UI.winterWet
            case .SNOW: return UI.winterSnowy
            case .ICE: return UI.winterIce
            case .LIKELY_WET_WITH_SALT: return UI.winterWet
            default: return season == .Summer ? UI.summerDry : UI.winterDry
            }
        }
    }
    
    var stationName = Observable("Unknown")
    var airTemp = Observable(19.1)
    var precipitationType = Observable(PrecipitationType.UNKNOWN)
    var roadTemp = Observable(0.0)
    var windSpeed = Observable(0.0)
    var windDirection = Observable(0.0)
    var precipitationIntensity = Observable(0.0)
    var visibility = Observable(0.0)
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
        debugPrint("update \(info.visibility.value)")
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
