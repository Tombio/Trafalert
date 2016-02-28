//
//  DataFetcher.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 02/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DataFetcher {
    
    //static let server = "http://localhost:8080"
    static let server = "https://trafalert.herokuapp.com"
    static let infoEndPoint = "/info" // get weather + warnings
    static let weatherEndPoint = "/weather" // get weather only
    static let warningEndPoint = "/warning" // get warnings only
    static let stationMetaEndPoint = "/meta/station"
    
    func updateWeatherInfo(station: Int, callback: (WeatherStationData) -> Void) {
        let address = String(format: "%@%@/%d", arguments:[DataFetcher.server, DataFetcher.infoEndPoint, station])
        debugPrint("Address \(address)")
        Alamofire.request(.POST, address, parameters: nil,
            headers: ["API_KEY": DataFetcher.apiKey]).responseJSON() {
                (response) in
                if let json = response.result.value {
                    if let weather = Mapper<WeatherStationData>().map(json) {
                        callback(weather)
                    }
                }
                else {
                    debugPrint("Failed to update info \(address) => \(response.result.error)")
                }
        }
    }
    
    func updateWarningStations(callback: (Array<WarningInfo>) -> Void){
        let address = String(format: "%@%@", arguments:[DataFetcher.server, DataFetcher.warningEndPoint])
        Alamofire.request(.POST, address, parameters: nil,
            headers: ["API_KEY": DataFetcher.apiKey]).responseJSON() {
                (response) in
                if let warnings = Mapper<WarningInfo>().mapArray(response.result.value) {
                    callback(warnings)
                }
        }
    }
    
    func fetchStationMetaData(callback: (Array<WeatherStationGroup>) -> Void) {
        let address = String(format: "%@%@", arguments:[DataFetcher.server, DataFetcher.stationMetaEndPoint])
        Alamofire.request(.POST, address, parameters: nil,
            headers: ["API_KEY": DataFetcher.apiKey]).responseJSON() {
                (response) in
                if let stations = Mapper<WeatherStationGroup>().mapArray(response.result.value) {
                    debugPrint("Stations \(stations.count)")
                    callback(stations)
                }
                else {
                    fatalError("Station fetching failed")
                }
        }
    }
    
    static var apiKey: String {
        if let path = NSBundle.mainBundle().pathForResource("properties", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            if let apiKey = dict["API_KEY"] {
                return apiKey as! String
            }
        }
        fatalError("Unable to read API key from properties.plist")
    }
}