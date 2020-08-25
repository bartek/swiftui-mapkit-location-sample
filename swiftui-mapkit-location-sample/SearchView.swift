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
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack() {
                Spacer()
                if locationService.status == .isSearching {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "magnifyingglass.circle")
                        .foregroundColor(.gray)
                }
                
                TextField("", text: $locationService.queryFragment)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            // searchResults will be populated by the searchCompleter
            List(locationService.searchResults, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text(result.title)
                    Text(result.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
      
        return SearchView().environmentObject(locationService)
    }
}
