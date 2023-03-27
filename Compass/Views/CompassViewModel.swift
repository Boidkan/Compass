//
//  CompassViewModel.swift
//  marketing-app
//
//  Created by eric collom on 2/9/23.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class CompassViewModel: ObservableObject {
    
    @Published var degrees: Double = 0
    @Published var degreesText: String = 0.text + "°"
    @Published var degreesToUSBank: Double?
    @ObservedObject private var locationService: LocationService
    
    @Published var degreesToTarget: Double?
    @Published var hotOrColdToTargetMessage: String = ""
    @Published var hotOrColdToTargetColor: Color = .black
    
    private var degreesFromTargetObserver: AnyCancellable?
    
    var isTargetUSBank: Bool {
        locationService.targetCoordinates?.latitude == locationService.usBankCoordinates.latitude &&
        locationService.targetCoordinates?.longitude == locationService.usBankCoordinates.longitude
    }
    
    init() {
        self.locationService = LocationService()
        
        
        degreesFromTargetObserver = locationService.$degreesFromTarget.sink { [weak self] degrees in
            guard let degrees = degrees,
                  let self = self
            else {
                return
            }
            
            self.hotOrColdToTargetColor = self.hotOrColdColor(for: degrees)
            self.hotOrColdToTargetMessage = self.hotOrColdString(for: degrees)
        }
        
        set(target: defaultMapItem)
        
        locationService.$headingDegrees.assign(to: &_degrees.projectedValue)
        locationService.$headingDegreesText.assign(to: &_degreesText.projectedValue)
        locationService.$degreesToUSBank.assign(to: &_degreesToUSBank.projectedValue)
        locationService.$degreesToTarget.assign(to: &_degreesToTarget.projectedValue)
    }
        
    
    func set(target: MapItem) {
        locationService.targetCoordinates = target.coordinate
    }
    
    var defaultMapItem: MapItem {
        locationService.usBankMapItem
    }
    
    func hotOrColdString(for degreesFromTarget: Double) -> String {
        if degreesFromTarget >= 0 && degreesFromTarget <= 1 {
            return "Found it! 🥳"
        } else if degreesFromTarget <= 15 {
            return "Close! ☀️"
        } else if degreesFromTarget <= 45 {
            return "Warmer 🌤"
        } else if degreesFromTarget <= 90 {
            return "Cold 🤧"
        } else if degreesFromTarget < 179 {
            return "Frozen 🥶"
        } else if degreesFromTarget <= 180 && degreesFromTarget >= 179 {
            return "💀"
        }
        return ""
    }
    
    func hotOrColdColor(for degreesFromTarget: Double) -> Color {
        if degreesFromTarget >= 0 && degreesFromTarget <= 1 {
            return .red
        } else if degreesFromTarget <= 15 {
            return Color.yellow
        } else if degreesFromTarget <= 45 {
            return Color.green
        } else if degreesFromTarget <= 90 {
            return Color.mint
        }
        
        return Color.blue
    }
}

