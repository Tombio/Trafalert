//
//  WeatherStationList.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 02/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftCSV

class WeatherStationList {

    static var weatherStations = WeatherStationList.initStationList()
    
    static func initStationList() -> [WeatherStation] {
        var ret = [WeatherStation]()
        let fileLocation = NSBundle.mainBundle().pathForResource("road_weather_stations", ofType: "csv")!
        let semicolon = NSCharacterSet(charactersInString: ";")
        let tsv: CSV!
        do {
            tsv = try CSV(contentsOfFile: fileLocation, delimiter: semicolon, encoding: NSUTF8StringEncoding)
            for row in tsv.rows {
                let id = Int(row["NUMERO"]!)!
                let title = row["NIMI_FI"]!
                let latitude = Double(row["Y"]!)!
                let longitude = Double(row["X"]!)!
                
                let station = WeatherStation(id, title, Int(row["TIE"]!)!, latitude, longitude)
                ret.append(station)
            }
        }
        catch _ {
            fatalError("Unable to read Weather Station info")
        }
        
        return ret
    }

}