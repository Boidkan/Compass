//
//  MapItemDetailsView.swift
//  marketing-app
//
//  Created by eric collom on 2/13/23.
//

import SwiftUI

struct MapItemDetailsView: View {
    
    @Binding var mapItem: MapItem
    
    var name: String {
        mapItem.shortAddress
    }
    
    var latitude: String {
        "\(mapItem.coordinate.latitude)"
    }
    
    var longitude: String {
        "\(mapItem.coordinate.longitude)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .top) {
                Text("Pointing to: ")
                    .foregroundColor(.red)
                Text(name)
            }
            HStack {
                Text("Latitude: ")
                    .foregroundColor(.red)
                Text(latitude)
            }
            
            HStack {
                Text("Longitude: ")
                    .foregroundColor(.red)
                Text(longitude)
            }
        }
    }
}

struct MapItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let item = MapItem(name: "Test with super long text that should wrap please",
                           latitude: 10,
                           longtitude: 10)
          
        MapItemDetailsView(mapItem: .constant(item))
    }
}

struct MapItemDetailsView_Previews2: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
