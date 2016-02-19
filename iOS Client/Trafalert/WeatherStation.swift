//
//  WeatherStation.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit
import ReactiveKit

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
    
    var monitoredLocations = Observable(Set<CLRegion>())
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.activityType = .AutomotiveNavigation
        self.locationManager.desiredAccuracy = 1000
        self.locationManager.startUpdatingLocation()
    }

    func setupRegionListening(currentLocation: CLLocation) {
        let sorted = WeatherStationList.sortedStations(currentLocation)
        let nearestStations = sorted[0..<4]
        
        clearLocationMonitors()
        var tempLocations = Set<CLRegion>()
        for weatherStation in nearestStations {
            let region = CLCircularRegion(center: weatherStation.location.coordinate, radius: 2000, identifier: weatherStation.name)
            tempLocations.insert(region)
            locationManager.startMonitoringForRegion(region)
        }
        if !(tempLocations == monitoredLocations.value) {
            monitoredLocations.value = tempLocations
        }
    }
    
    func clearLocationMonitors() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoringForRegion(region)
        }
    }
    
    func listeningRegion(identifier: String) -> Bool {
        for region in monitoredLocations.value {
            if region.identifier == identifier {
                print("We are listening to area \(identifier)")
                return true
            }
        }
        return false
    }
    
    // MARK: CLLocationMangerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Here we check that we have closest regions at surveillance and update locationManager accordingly
        guard let _ = locations.first else {
            return
        }
        self.setupRegionListening(locations.first!)
    }
}