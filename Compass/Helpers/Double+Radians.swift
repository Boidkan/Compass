//
//  Double+Radians.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import Foundation

extension Double {
    var radiansToDegress: Double {
        return self * 180 / .pi
    }
    
    var degreesToRadians: Double {
        return self * .pi / 180
    }
}
