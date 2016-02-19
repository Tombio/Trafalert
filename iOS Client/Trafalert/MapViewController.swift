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

    let locationHandler = LocationManagerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        for ws in WeatherStationList.weatherStations {
            mapView.addAnnotation(WeatherStationAnnotation(title: "Asema", subtitle: "Varoitukset", stationName: ws.name, active: true, coord: ws.coordinate))
        }
        
        // Register observer for monitored locations
        locationHandler.monitoredLocations.observe { value in
            var updatingOverlays = self.activeOverlays()
            updatingOverlays.appendContentsOf(self.overlaysToActivate(value))
            for overlay in updatingOverlays {
                self.mapView.removeOverlay(overlay)
                self.mapView.addOverlay(overlay)
            }
        }
    }
    
    func activeOverlays() -> [MKOverlay] {
        return mapView.overlays.filter({
            return ($0 as! WeatherStationAnnotation).active
        })
    }
    
    func overlaysToActivate(regions: Set<CLRegion>) -> [MKOverlay] {
        return mapView.overlays.filter({
            for region in regions {
                if ($0 as! WeatherStationAnnotation).stationName == region.identifier {
                    return true
                }
            }
            return false
        })
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
    
    /*
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let wsOverlay = overlay as! WeatherStationOverlay
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        wsOverlay.active = self.locationHandler.listeningRegion(wsOverlay.stationName!)
        let color = wsOverlay.active ? UIColor.greenColor() : UIColor.purpleColor()
        circleRenderer.strokeColor = color
        circleRenderer.fillColor = color.colorWithAlphaComponent(0.3)
        return circleRenderer
    }*/
}