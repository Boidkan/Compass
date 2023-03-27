//
//  SearchBarView.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    var placeHolderText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? .secondary : .blue
                )
            TextField("Search", text: $searchText)
                .foregroundColor(.blue)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.blue)
                        .padding()
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            searchText = ""
                            hideKeyboard()
                        }
                    , alignment: .trailing
                )
                
        }
        .font(.headline)
        .padding()
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .black.opacity(0.5),
                        radius: 3,
                        x: 1,
                        y: 1)
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {

    static var previews: some View {
        SearchBarView(searchText: .constant("test"), placeHolderText: "Search Test Place Holder")
    }
}

