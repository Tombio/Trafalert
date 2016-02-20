//
//  WarningInfo.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 21/02/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import ObjectMapper
import ReactiveKit

class WarningInfo: Mappable {

    var stationId = 0
    var warnings = Array<Warning>()
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        stationId = map["stationId"].currentValue as! Int
        if let warn = Mapper<Warning>().mapArray(map["warnings"].currentValue) {
            warnings = warn
        }
        else {
            warnings = Array<Warning>()
        }

    }
}
