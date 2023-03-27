//
//  CompassArrowView.swift
//  marketing-app
//
//  Created by eric collom on 2/9/23.
//

import SwiftUI

struct CompassArrowView: View {
    var bearing: Double
    let compassDegrees: Double
    
    private var paddingBottom: CGFloat { 85 }
    
    private var textAngle: Angle {
        Angle(degrees: -compassDegrees - bearing)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "triangle.fill")
                .foregroundColor(.red)
                .padding(.bottom, -2)
                .padding(.top, 0)
            Capsule()
                .frame(width: 5,
                       height: 40)
                .foregroundColor(.red)
                .padding(.top, 0)
                .padding(.bottom, paddingBottom)
        }
        .padding(.bottom, 120)
        .rotationEffect(Angle(degrees: bearing))
    }
}

struct CompassArrowView_Previews: PreviewProvider {
    static var previews: some View {
        CompassArrowView(bearing: 0, compassDegrees: 0)
    }
}


struct CompassArrowView_Previews2: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}


