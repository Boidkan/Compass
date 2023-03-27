//
//  MKPlacemark+StringFormatting.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import MapKit

extension MKPlacemark {

    var shortAddress: String? {
        guard let name = self.name,
              let city = self.locality
        else {
            return nil
        }
        
        return name + ", " + city
    }
}
