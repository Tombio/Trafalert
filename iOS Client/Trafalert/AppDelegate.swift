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
    
    // Need to clean this mess at some point
    var currentWeather  = WeatherInfo()
    var currentWarnings = Array<Warning>()
    var currentStation: WeatherStation?
    var currentData = WeatherStationData()
    var currentLocation = Observable(CLLocation(latitude: 0.0, longitude: 0.0))
  
    var lastUpdateTime: NSDate?
    var spokenVersions = [Int:Int]() // [id:lastVersion]
    let locationManager = CLLocationManager()
    let motionManager = CMMotionActivityManager()
    let dataFetcher = DataFetcher()
    let speechSynth = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice(language: "fi-FI")
    
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
        locationManager.activityType = .AutomotiveNavigation
        locationManager.desiredAccuracy = 1000
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
    
    func checkWarningsAndTalk(){
        debugPrint("Check for talk")
        if !currentData.warnings.isEmpty { // We can safely assume that once warnings are present, so is station id
            let id = currentData.stationId!
            if let lastVersion = spokenVersions[id] {
                if let maxVersion = currentData.warnings.collection.maxVersion() {
                    if lastVersion < maxVersion {
                        spokenVersions[id] = speakFromVersion(lastVersion)
                    }
                }
            }
            else {
                spokenVersions[id] = speakFromVersion(0)
            }
        }
        else {
            debugPrint("Nothing to talk.. no warnings..")
        }
    }
    
    func speakFromVersion(version: Int) -> Int {
        debugPrint("Speak from version \(version)")
        var max = version
        for w in currentData.warnings {
            if version < w.version.value {
                debugPrint("Send to talk")
                talk("Varoitus: Tielle numero \(currentStation!.roadNumber): \(w.warningType.value.humanReadable())")
                max = w.version.value > max ? w.version.value : max
            }
            else {
                debugPrint("\(version) => \(w.version.value)")
            }
        }
        return max
    }
    
    // MARK: Speak, my young Padawan
    
    func talk(string: String) {
        debugPrint("Speak \(string)")
        
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = voice
        speechSynth.speakUtterance(utterance)
    }
    
    // MARK: Callback setter

    func setWeather(info: WeatherStationData) {
        currentData.warnings.replace(info.warnings.collection)
        currentData.stationId = info.stationId
        if currentStation != nil {
            info.info.stationName.value = currentStation!.name
        }
        currentWeather.updateWith(info.info)
        checkWarningsAndTalk()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
      currentLocation.value = newLocation
      if timeToUpdate(){
        let nearestStation = WeatherStationList.nearestStation(newLocation)
        debugPrint("Location update \(newLocation)")
        currentStation = nearestStation
        dataFetcher.updateWeatherInfo(nearestStation.id, callback: setWeather)
        lastUpdateTime = NSDate()
      }
    }
    
    /**
    * Update after 60 seconds has passed from last update.
    */
    func stationChanged(nearestStation: WeatherStation) -> Bool {
        return currentStation == nil || nearestStation.id != currentStation?.id
    }
  
    func timeToUpdate() -> Bool {
        return lastUpdateTime == nil || NSDate().timeIntervalSinceDate(lastUpdateTime!) > 60
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Ask from server info about entered region
        print("Did enter region at app delegate \(region)")
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // NOP
    }
    
}

