//
//  CompassMarkerView.swift
//  marketing-app
//
//  Created by eric collom on 2/9/23.
//

import SwiftUI

struct CompassMarkerView: View {
    
    var marker: CompassMarker
    let compassDegrees: Double
    
    private var capsuleWidth: CGFloat {
        marker.showDegrees ? 3 : 1.5
    }
    
    private var capsuleHeight: CGFloat {
        marker.showDegrees ? 30 : 15
    }
    
    private var capsuleColor: Color {
        marker.degrees == 0 ? .red : Color(uiColor: UIColor.lightGray)
    }
    
    private var textAngle: Angle {
        Angle(degrees: -compassDegrees - marker.degrees)
    }
    
    private var degreeTextPaddingBottom: CGFloat {
        marker.degrees == 0 ? 0 : 8
    }
    
    private var labelPaddingBottom: CGFloat {
        marker.label.isEmpty ? 80 : 60
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("\(marker.degreeText)")
                .fontWeight(.light)
                .rotationEffect(textAngle)
                .hideIf(marker.showDegrees == false)
                .padding(.bottom, degreeTextPaddingBottom)
            Capsule()
                .frame(width: capsuleWidth,
                       height: capsuleHeight)
                .foregroundColor(capsuleColor)
                .padding(.top, 0)
            Text(marker.label)
                .font(.system(size: 23, weight: .semibold))
                .rotationEffect(textAngle)
                .padding(.bottom, labelPaddingBottom)
                .padding(.top, 3)
                .foregroundColor(marker.degrees == 0 ? .red : Color(uiColor: UIColor.lightGray))
        }
        .padding(.bottom, 120)
        .rotationEffect(Angle(degrees: marker.degrees))
    }
}

struct CompassMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        CompassMarkerView(marker: CompassMarker(degrees: 0, label: "S"),
                          compassDegrees: 0)
    }
}

struct CompassMarkerView_Previews2: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}

