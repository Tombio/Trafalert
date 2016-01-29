//
//  WeatherStation.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit
import SwiftCSV

struct WeatherStation {
    
    let id: Int
    let name: String
    let roadNumber: Int
    let location: CLLocation
    
    var coordinate: CLLocationCoordinate2D {
        return self.location.coordinate
    }
    
    init(_ id: Int, _ name: String, _ roadNumber: Int, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        self.id = id
        self.name = name
        self.roadNumber = roadNumber
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}

class LocationManagerHandler: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static var weatherStations = LocationManagerHandler.initStationList()
    var monitoredLocations = Set<CLRegion>()
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        setupRegionListening(locationManager.location!)
    }

    func setupRegionListening(currentLocation: CLLocation) {
        print("setup region listening")
        LocationManagerHandler.weatherStations.sortInPlace({
            return $0.location.distanceFromLocation(currentLocation) < $1.location.distanceFromLocation(currentLocation)
        })
        
        let nearestStations = LocationManagerHandler.weatherStations[0..<4]
        monitoredLocations.removeAll()
        for weatherStation in nearestStations {
            let region = CLCircularRegion(center: weatherStation.location.coordinate, radius: 2000, identifier: weatherStation.name)
            monitoredLocations.insert(region)
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    func listeningRegion(identifier: String) -> Bool {
        for region in locationManager.monitoredRegions {
            if region.identifier == identifier {
                return true
            }
        }
        return false
    }
    
    // MARK: CLLocationMangerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Received location update")
        // Here we check that we have closest regions at surveillance and update locationManager accordingly
        guard let _ = locations.first else {
            return
        }
        self.setupRegionListening(locations.first!)
    }
    
    // MARK: Static initialization of Weather Station data
    
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