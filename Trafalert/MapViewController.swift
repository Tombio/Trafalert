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
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        for ws in weatherStation {
            mapView.addOverlay(MKCircle(centerCoordinate: ws.coordinate, radius: 2000))
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "weatherStation"
        if annotation is WeatherStation {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.leftCalloutAccessoryView = nil
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.purpleColor()
        circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
        return circleRenderer
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
                let title = row["NIMI_FI"]!
                let latitude = Double(row["Y"]!)!
                let longitude = Double(row["X"]!)!
                
                let station = WeatherStation(title, Int(row["TIE"]!)!, latitude, longitude)
                ret.append(station)
            }
        }
        catch _ {
            fatalError("Unable to read Weather Station info")
        }
        
        return ret
    }
}