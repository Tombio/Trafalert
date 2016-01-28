//
//  MapViewController.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 28/01/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SwiftCSV

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    let weatherStation = MapViewController.initStationList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: Static initialization of Weather Station data
    
    static func initStationList() -> [WeatherStation] {
        var ret = [WeatherStation]()
        let fileLocation = NSBundle.mainBundle().pathForResource("road_weather_stations", ofType: "csv")!
        let semicolon = NSCharacterSet(charactersInString: ";")
        var error: NSErrorPointer = nil
        let tsv: CSV!
        do {
            tsv = try CSV(contentsOfFile: fileLocation, delimiter: semicolon, encoding: NSUTF8StringEncoding)
            for row in tsv.rows {
                let station = WeatherStation(name: row["NIMI_FI"]!, roadNumber: Int(row["TIE"]!)!, latitude: Double(row["X"]!)!, longitude: Double(row["Y"]!)!)
                ret.append(station)
                print(station)
            }
        }
        catch _ {
            fatalError("Unable to read Weather Station info")
        }
        
        return ret
    }
}