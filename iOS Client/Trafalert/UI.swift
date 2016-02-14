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
    static let middleLeft = UIColor(106, 186, 238, 80)
    static let middleCenter = UIColor(91, 177, 233, 80)
    static let middleRight = UIColor(75, 167, 227, 80)
    
    static let warning = UIColor(134, 56, 56, 80)
    
}

extension UIColor {
    // Init UIColor with simple (r[0-255], g[0-255], b[0-255], a[0-100]) initializer
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/100)
    }
}