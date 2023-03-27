//
//  SearchView.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel = MapSearchViewModel()
    
    @State private var searchText = ""
    @Binding var selectedMapItem: MapItem
    
    var body: some View {
        ZStack {
            VStack() {
                SearchBarView(searchText: $searchText, placeHolderText: "Search Address")
                    .padding(.horizontal, 20)
                
                List(viewModel.mapItems, id: \.id) { item in
                    Button {
                        selectedMapItem = item
                    } label: {
                        Text(item.address)
                    }
                }
                .hideIf(viewModel.mapItems.count == 0)
                .listStyle(.plain)
            }
            .onChange(of: searchText) { newText in
                viewModel.search(term: newText)
            }
            .onChange(of: selectedMapItem) { newValue in
                searchText = ""
                hideKeyboard()
            }
        }
        .background(viewModel.mapItems.count == 0 ? .clear : .white)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedMapItem: .constant(MapItem(name: "123", latitude: 123, longtitude: 123)))
    }
}

