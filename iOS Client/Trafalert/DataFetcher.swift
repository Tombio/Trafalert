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
    
    func updateWeatherInfo(station: Int, callback: (WeatherStationData) -> Void) {
        let address = String(format: "%@%@/%d", arguments:[DataFetcher.server, DataFetcher.infoEndPoint, station])
        Alamofire.request(.POST, address, parameters: nil,
            headers: ["API_KEY": DataFetcher.apiKey]).responseJSON() {
                (response) in
                debugPrint(response.result)
                if let json = response.result.value {
                    debugPrint(json)
                    if let weather = Mapper<WeatherStationData>().map(json) {
                        callback(weather)
                    }
                }
                else {
                    debugPrint("Failed to update info \(response.result.error)")
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