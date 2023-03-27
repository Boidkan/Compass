//
//  MapSearchViewModel.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import Foundation
import MapKit

class MapSearchViewModel: ObservableObject {
    
    private let locationService = LocationService()
    
    @Published private(set) var mapItems: [MapItem] = []
    
    func search(term: String) {
        
        let term = term.trimmed
        
        if term.count > 3 {
            
            locationService.getMapItems(for: term) { items in
                DispatchQueue.main.async {
                    
                    self.mapItems = items.compactMap { MapItem(item: $0) }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.mapItems.removeAll()
            }
        }
    }
    
    func clearMapItems() {
        self.mapItems = []
    }
}
