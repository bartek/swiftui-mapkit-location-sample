//
//  SearchView.swift
//  swiftui-mapkit-location-sample
//
//  Created by Bartek Ciszkowski on 2020-08-24.
//  Copyright © 2020 Bartek Ciszkowski. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @EnvironmentObject var searchService: SearchService
    @Binding var showingSearch: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack() {
                Spacer()
                if searchService.status == .isSearching {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "magnifyingglass.circle")
                        .foregroundColor(.gray)
                }
                
                TextField("", text: $searchService.queryFragment)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            // searchResults will be populated by the searchCompleter within SearchService
            List(searchService.searchResults, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text(result.title)
                    Text(result.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }.onTapGesture {
                    self.searchService.searchForMapItems(for: result.title)
                    self.showingSearch.toggle()
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var showingSearch = false
    static var previews: some View {
        let searchService = SearchService()
      
        return SearchView(showingSearch: $showingSearch).environmentObject(searchService)
    }
}
