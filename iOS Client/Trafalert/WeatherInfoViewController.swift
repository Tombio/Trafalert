//
//  WeatherInfiViewController.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 02/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit
import ReactiveFoundation
import ReactiveUIKit

class WeatherInfoViewController: UIViewController {
    
    @IBOutlet weak var stationNameLbl: UILabel!
    @IBOutlet weak var airTempLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var rainLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var roadTempLbl: UILabel!
    @IBOutlet weak var freezingPointLbl: UILabel!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var roadSurfaceConditionLbl: UILabel!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var locationDebug: UILabel!
  
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLbl.numberOfLines = 4
        locationDebug.numberOfLines = 2
        // Bind some stuff
        appDelegate.currentWeather.stationName.bindTo(stationNameLbl)
        appDelegate.currentWeather.airTemp.observe { value in
            self.airTempLbl.text = String(format: " %0.1f°", value)
        }
        appDelegate.currentWeather.precipitationType.observe { value in
            self.conditionLbl.text = value.humanReadable()
        }
        appDelegate.currentWeather.precipitationIntensity.observe { value in
            self.rainLbl.text = String(format: "%i mm/h", value)
        }
        appDelegate.currentWeather.visibility.observe { value in
            let format = "Näkyvyys " + (value < 1000 ? "%i m" : "%i km");
            self.visibilityLbl.text = String(format: format, value < 1000 ? value : value / 1000)
        }
        appDelegate.currentWeather.windSpeed.observe { value in
            self.windDirection.text = "\(value)"
        }
        appDelegate.currentWeather.windDirection.observe { value in
            self.rotateImage(Float(value))
        }
        appDelegate.currentWeather.roadTemp.observe {value in
            self.roadTempLbl.text = String(format: " %0.1f°", value)
        }
        appDelegate.currentWeather.dewPoint.observe { value in
            let actual = value > 0 ? 0.0 : value
            self.freezingPointLbl.text = String(format: "Tienpinnan jäätymislämpötila: %0.1f°", actual)
        }
        appDelegate.currentWeather.roadSurfaceCondition.observe { value in
            self.roadSurfaceConditionLbl.text = value.humanReadable()
        }
        appDelegate.currentData.warnings.observe { value in
            self.warningView.hidden = value.collection.isEmpty
            let warningString = value.collection.reduce("", combine: {
                $0 == "" ? $1.warningType.value.humanReadable() : $0 + "\n" + $1.warningType.value.humanReadable()
            })
            self.warningLbl.text = warningString
        }
        appDelegate.currentLocation.observe { value in
            self.locationDebug.text = String(format: "%0.4f\n%0.4f", value.coordinate.latitude, value.coordinate.longitude)
        }
    }
    
    func rotateImage(wind: Float) {
        let direction: Float = wind * (Float)(M_PI) / 180.0
        UIView.animateWithDuration(1.0, animations: {
            self.windImage.transform = CGAffineTransformMakeRotation(CGFloat(direction))
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}