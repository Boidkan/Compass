//
//  MapItem.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import SwiftUI
import MapKit

struct MapItem: Identifiable, Equatable {
    
    var address: String
    var shortAddress: String
    var name: String
    var coordinate: CLLocationCoordinate2D
    var pinIcon: String?
    
    var id: String {
        address + "_\(coordinate.latitude)" + "_\(coordinate.longitude)"
    }
    
    init?(item: MKMapItem) {
        
        guard let name = item.placemark.title,
              let shortName = item.placemark.name,
              let shortAddress = item.placemark.shortAddress,
              let coord = item.placemark.location?.coordinate
        else {
            return nil
        }
        
        self.address = name
        self.name = shortName
        self.shortAddress = shortAddress
        self.coordinate = coord
    }
    
    init(name: String, latitude: Double, longtitude: Double, pinIcon: String? = nil) {
        self.address = name
        self.name = name
        self.shortAddress = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        self.pinIcon = pinIcon
    }
    
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        return lhs.id == rhs.id
    }
    
}

