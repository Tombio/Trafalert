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
import ReactiveKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Register observer for monitored locations
        appDelegate.warningStations.observe { value in
            self.mapView.removeAnnotations(self.mapView.annotations)
            for id in value.collection {
                if let ws = WeatherStationList.weatherStation(id) {
                    let annotation = WeatherStationAnnotation(
                        title: ws.name, subtitle: "",
                        stationName: ws.name, active: true, coord: ws.coordinate)
                    self.mapView.addAnnotation(annotation)
                }
            }
            
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? WeatherStationAnnotation {
            let identifier = "weatherStation"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
}