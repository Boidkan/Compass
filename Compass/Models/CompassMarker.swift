//
//  CompassMarker.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import Foundation

struct CompassMarker: Hashable {
    let degrees: Double
    let label: String
    let showDegrees: Bool

    init(degrees: Double,
         label: String = "",
         showDegrees: Bool = true) {
        self.degrees = degrees
        self.label = label
        self.showDegrees = showDegrees
    }
    
    var degreeText: String {
        degrees.text
    }
    
    static var allMarkers: [CompassMarker] {
        var degrees: Double = 0
        var markers: [CompassMarker] = []
        
        var label: String {
            switch degrees {
            case 0: return "N"
            case 90: return "E"
            case 180: return "S"
            case 270: return "W"
            default: return ""
            }
        }
        
        var shouldShowDegrees: Bool {
            return degrees.truncatingRemainder(dividingBy: 30) == 0 || label != ""
        }
        
        while degrees < 360 {
            let marker = CompassMarker(degrees: degrees,
                                       label: label,
                                       showDegrees: shouldShowDegrees)
            markers.append(marker)
            degrees += 3
        }
        
        return markers
    }
}

