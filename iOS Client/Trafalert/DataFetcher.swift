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
    
    //static var server = "http://localhost:8080"
    static var server = "http://trafalert.herokuapp.com"
    static var infoEndPoint = "/info" // get weather + warnings
    static var weatherEndPoint = "/weather" // get weather only
    static var warningEndPoint = "/warning" // get warnings only
    
    func updateWeatherInfo(station: Int, callback: (WeatherStationData) -> Void) {
        let address = String(format: "%@%@/%d", arguments:[DataFetcher.server, DataFetcher.infoEndPoint, station])
        debugPrint(address)
        Alamofire.request(.GET, address)
            .responseJSON { response in
                if let json = response.result.value {
                    debugPrint(json)
                    if let weather = Mapper<WeatherStationData>().map(json) {
                        callback(weather)
                    }
                }
                else {
                    debugPrint("Failed to update info")
                }
        }
    }
}