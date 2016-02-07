//
//  AppDelegate.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import AVFoundation
import ReactiveKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var currentWeather  = WeatherInfo()
    var currentWarnings = Array<Warning>()
    var currentStation: WeatherStation?
    var currentData = WeatherStationData()
    var inCar = Observable(false)
    
    var lastUpdateTime: NSDate?
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionActivityManager()
    let dataFetcher = DataFetcher()
    let speechSynth = AVSpeechSynthesizer()
    // let voice = AVSpeechSynthesisVoice(language: "fi-FI")
    
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
        // Also start stalking motion data if possible
        if CMMotionActivityManager.isActivityAvailable() {
            motionManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                (activity: CMMotionActivity?) -> Void in
                self.inCar.value = activity?.automotive == true
            })
        }
        else {
            debugPrint("No activity monitoring.. :(")
        }
        
        
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
    
    // MARK: Speak, my young Padawan
    
    func talk(string: String) {
        debugPrint("Speak \(string)")
        
        let utterance = AVSpeechUtterance(string: string)
        // utterance.voice = voice
        speechSynth.speakUtterance(utterance)
    }
    
    // MARK: Callback setter

    func setWeather(info: WeatherStationData) {
        currentData.warnings.replace(info.warnings.collection)
        if currentStation != nil {
            info.info.stationName.value = currentStation!.name
        }
        currentWeather.updateWith(info.info)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let nearestStation = WeatherStationList.nearestStation(newLocation)
        if timeToUpdate(nearestStation) {
            debugPrint("Location update \(newLocation)")
            currentStation = nearestStation
            dataFetcher.updateWeatherInfo(nearestStation.id, callback: setWeather)
            lastUpdateTime = NSDate()
        }
    }
    
    /**
    * Update if there is now currentStation (first run), nearest station has changed, 
    * last update time is unknown or it has been more than 30 seconds since last update
    */
    func timeToUpdate(nearestStation: WeatherStation) -> Bool {
        return currentStation == nil || nearestStation.id != currentStation?.id ||
            lastUpdateTime == nil || NSDate().timeIntervalSinceDate(lastUpdateTime!) > 30
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Ask from server info about entered region
        print("Did enter region at app delegate \(region)")
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // NOP
    }
}

