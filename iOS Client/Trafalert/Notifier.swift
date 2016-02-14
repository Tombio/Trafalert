//
//  Notifier.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 14/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class Notifier {

    static func sendNotification(warning: Warning, station: WeatherStation, warningCount: Int) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.alertTitle = warning.warningType.value.humanReadable()
        localNotification.alertBody = station.name
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = warningCount
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}
