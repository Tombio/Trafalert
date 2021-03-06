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
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    // Need to clean this mess at some point
    var currentWeather  = WeatherInfo()
    var currentWarnings = Array<Warning>()
    var currentStation: WeatherStationGroup?
    var currentData = WeatherStationData()
    var currentLocation = Observable(CLLocation(latitude: 0.0, longitude: 0.0))
    var warningStations = ObservableCollection(Array<WarningInfo>())
    var weatherStationGroups = Array<WeatherStationGroup>()
  
    var lastUpdateTime: NSDate?
    var spokenVersions = [Int:Int]() // [id:lastVersion]
    let locationManager = CLLocationManager()
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
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            UIApplication.sharedApplication().registerUserNotificationSettings(
                UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.activityType = .AutomotiveNavigation
        locationManager.desiredAccuracy = 500
        Fabric.with([Crashlytics.self])
        dataFetcher.fetchStationMetaData(stationMetaSetter)
        
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
        application.applicationIconBadgeNumber = 0
    }
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.locationManager.startMonitoringSignificantLocationChanges()
        return true
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func checkWarningsAndTalk(){
        if !currentData.warnings.isEmpty { // We can safely assume that once warnings are present, so is station id
            guard let id = currentData.stationId else {
                debugPrint("Current station was empty after all")
                return
            }
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
            debugPrint("No warnings")
        }
    }
    
    func speakFromVersion(version: Int) -> Int {
        var max = version
        for w in currentData.warnings {
            if version < w.version {
                talk("Varoitus: \(currentStation!.name): \(w.warningType.value.humanReadable())")
                Notifier.sendNotification(w, station: currentStation!, warningCount: currentData.warnings.count)
                max = w.version > max ? w.version : max
            }
        }
        return max
    }
    
    // MARK: Speak, my young Padawan
    
    func talk(string: String) {
        debugPrint("Talk: \(string)")
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
    
    func warningStations(stations: Array<WarningInfo>) {
        self.warningStations.replace(stations)
    }
    
    func stationMetaSetter(stations: Array<WeatherStationGroup>) {
        debugPrint("Meta data received. Start updating location")
        self.weatherStationGroups = stations
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation.value = newLocation
        if weatherStationGroups.isEmpty {
            return
        }
        if timeToUpdate(){
            let nearestStation = findNearestStation()
            currentStation = nearestStation
            dataFetcher.updateWeatherInfo(nearestStation.id, callback: setWeather)
            dataFetcher.updateWarningStations(warningStations)
            lastUpdateTime = NSDate()
        }
    }
    
    func findNearestStation() -> WeatherStationGroup {
        var distance = Double.infinity
        var station = weatherStationGroups.first!
        for wsg in weatherStationGroups {
            let d = wsg.location!.distanceFromLocation(currentLocation.value)
            if d < distance {
                distance = d
                station = wsg
            }
        }
        return station
    }
    
    func stationGroupForId(id: Int) -> WeatherStationGroup? {
        for w in weatherStationGroups {
            if w.id == id {
                return w
            }
        }
        return nil
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
    
    
    // Mark: - All the rest
    
    func stationHasWarning(id: Int) -> Bool {
        return true
    }
}

