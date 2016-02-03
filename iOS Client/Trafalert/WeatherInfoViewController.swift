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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bind some stuff
        appDelegate.currentWeather.stationName.bindTo(stationNameLbl)
        appDelegate.currentWeather.airTemp.observe { value in
            self.airTempLbl.text = String(format: "%0.1f°", value)
        }
        appDelegate.currentWeather.condition.bindTo(conditionLbl)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}