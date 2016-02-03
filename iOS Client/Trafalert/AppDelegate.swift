//
//  AppDelegate.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var currentWeather = WeatherInfo()
    var currentStation: WeatherStation?
    
    let locationManager = CLLocationManager()
    let dataFetcher = DataFetcher()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // setup location manager to receive updates all the time
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.locationManager.startMonitoringSignificantLocationChanges()
        return true
        
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    // MARK: Callback setter

    func setWeather(info: WeatherInfo) {
        if currentStation != nil {
            info.stationName.value = currentStation!.name
        }
        currentWeather.updateWith(info)
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let nearestStation = WeatherStationList.nearestStation(newLocation)
        debugPrint("Location update \(newLocation)")
        if let cs = currentStation {
            if cs.id == nearestStation.id {
                // Update weather info to reflect nearest station
                dataFetcher.updateWeatherInfo(nearestStation.id, callback: setWeather)
            }
        }
        else {
            currentStation = nearestStation
            // Update weather info to reflect nearest station
            dataFetcher.updateWeatherInfo(nearestStation.id, callback: setWeather)

        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Ask from server info about entered region
        print("Did enter region at app delegate \(region)")
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // NOP
    }
}

