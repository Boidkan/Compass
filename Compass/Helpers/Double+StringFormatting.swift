//
//  Double+StringFormatting.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import Foundation

extension Double {
    var text: String {
        String(format: "%.0f", self)
    }
    
    var stringWithoutTrailingZeros: String {
        String(format: "%g", self)
    }
}
