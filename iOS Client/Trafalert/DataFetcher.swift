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
    
    static var server = "http://localhost:8080"
    static var weatherEndPoint = "/weather"
    static var warningEndPoint = "/warning"
    
    func updateWeatherInfo(station: Int, callback: (WeatherInfo) -> Void) {
        let address = String(format: "%@%@/%d", arguments:[DataFetcher.server, DataFetcher.weatherEndPoint, station])
        debugPrint(address)
        Alamofire.request(.GET, address)
            .responseJSON { response in
                if let json = response.result.value {
                    if let weather = Mapper<WeatherInfo>().map(json) {
                        callback(weather)
                    }
                }
                else {
                    debugPrint("Failed to update info")
                }
        }
    }
}