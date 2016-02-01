//
//  WeatherInfo.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 01/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import ReactiveKit

struct WeatherInfo {
    var stationName = Observable("Unknown")
    var airTemp = Observable(19.11)
    var roadTemp: Double?
    var windSpeed: Double?
    var windDirection: Int?
}
