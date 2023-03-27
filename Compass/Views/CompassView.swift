//
//  CompassView.swift
//  marketing-app
//
//  Created by eric collom on 2/9/23.
//


import SwiftUI


struct CompassView: View {

    @StateObject var viewModel: CompassViewModel
    @State var selectedMapItem: MapItem
    private var compassMarkers = CompassMarker.allMarkers
    
    init() {
        let vm = CompassViewModel()
        self._viewModel = StateObject(wrappedValue: vm)
        self.selectedMapItem = vm.defaultMapItem
        
        
    }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                FindLocationView(address: $selectedMapItem.shortAddress,
                                 textColor: $viewModel.hotOrColdToTargetColor,
                                 hotOrColdMessage: $viewModel.hotOrColdToTargetMessage)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                
                Text(viewModel.degreesText)
                    .font(.system(size: 30))
                    .padding(.bottom, 3)
                    .padding(.leading, 11)

                Capsule()
                    .frame(width: 4,
                           height: 35)
                    .foregroundColor(.red)
                ZStack {
                    ForEach(compassMarkers, id: \.self) { marker in
                        CompassMarkerView(marker: marker,
                                          compassDegrees: viewModel.degrees)
                    }
                    
                    if let bearing = viewModel.degreesToTarget {
                        CompassArrowView(bearing: bearing,
                                         compassDegrees: viewModel.degrees)
                    }
                }
                .frame(width: 300,
                       height: 300)
                .rotationEffect(Angle(degrees: viewModel.degrees))
                Spacer()
                Spacer()
            }.ignoresSafeArea(.all)
            
            SearchView(selectedMapItem: $selectedMapItem)
        }
        .padding(.top, 105)
        .ignoresSafeArea(.all)
        .onChange(of: selectedMapItem) { item in
            viewModel.set(target: item)
        }
        
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CompassView()
                .navigationTitle("Test")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
