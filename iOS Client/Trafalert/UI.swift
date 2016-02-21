//
//  UI.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 13/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

public class UI {
    //6abaee 106 186 238
    static let middleLeft = UIColor(106, 186, 238, 95)
    static let middleCenter = UIColor(91, 177, 233, 95)
    static let middleRight = UIColor(75, 167, 227, 95)
    static let warning = UIColor(255, 101, 101, 95)
    
    static let rainBackground = UIImage(named: "Rain Sky")!
    static let rainBackgroundDay = UIImage(named: "Day Rain Sky")!
    static let rain = UIImage(named: "Rain")!
    static let snow = UIImage(named: "Snow")!
    
    static let summerDry = UIImage(named: "Summer Dry")!
    static let summerWet = UIImage(named: "Summer Wet")!
    
    static let winterDry = UIImage(named: "Winter Dry")!
    static let winterWet = UIImage(named: "Winter Snow")!
    static let winterSnowy = UIImage(named: "Winter Snow")!
    static let winterIce = UIImage(named: "Winter Ice")!
    
    static let clearNight = UIImage(named: "Clear Night Sky")!
    static let clearDay = UIImage(named: "Clear Sky")!
    static let cloudyNight = UIImage(named: "Cloudy Night Sky")!

}

extension UIColor {
    // Init UIColor with simple (r[0-255], g[0-255], b[0-255], a[0-100]) initializer
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/100)
    }
}