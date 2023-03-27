//
//  FindLocationView.swift
//  marketing-app
//
//  Created by eric collom on 2/14/23.
//

import SwiftUI

struct FindLocationView: View {
    
    @Binding var address: String
    @Binding var textColor: Color
    @Binding var hotOrColdMessage: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Find the address on the compass!")
                .foregroundColor(textColor)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            Text(address)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(textColor)
            
            
            Text(hotOrColdMessage)
                .foregroundColor(textColor)
        }
    }
}

struct FindLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FindLocationView(address: .constant("My Test Address"),
                         textColor: .constant(.blue),
                         hotOrColdMessage: .constant("Cold"))
    }
}
