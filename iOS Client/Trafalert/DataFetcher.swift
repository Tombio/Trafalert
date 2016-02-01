//
//  DataFetcher.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 02/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import Alamofire

class DataFetcher {
    
    static var server = "http://localhost:8080"
    static var weatherEndPoint = "/weather"
    static var warningEndPoint = "/warning"
    
    func updateWeatherInfo(station: Int) {
        let address = String(format: "%@%@%@", arguments: [DataFetcher.server, DataFetcher.weatherEndPoint, station])
        debugPrint(address)
        Alamofire.request(.GET, address)
            .responseJSON { response in
                debugPrint(response)
        }
    }
    
}