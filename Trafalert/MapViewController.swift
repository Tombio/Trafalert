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


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationHandler = LocationManagerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        for ws in LocationManagerHandler.weatherStations {
            mapView.addOverlay(WeatherStationOverlay.createOverlay(ws.coordinate, 2000, ws.name))
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
        let wsOverlay = overlay as! WeatherStationOverlay
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        let color = self.locationHandler.listeningRegion(wsOverlay.stationName!) ? UIColor.greenColor() : UIColor.purpleColor()
        circleRenderer.strokeColor = color
        circleRenderer.fillColor = color.colorWithAlphaComponent(0.3)
        return circleRenderer
    }
}