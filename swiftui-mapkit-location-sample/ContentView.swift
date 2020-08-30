//
//  ContentView.swift
//  swiftui-mapkit-location-sample
//
//  Created by Bartek Ciszkowski on 2020-08-21.
//  Copyright © 2020 Bartek Ciszkowski. All rights reserved.
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var searchService: SearchService
    
    @State var showingSearch: Bool = false;
    
    let regionRadius: CLLocationDistance = 1000
    
    var body: some View {
        
        let userLocation = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        // The map centers on the most recently added annotation or the user location
        var centerCoordinate: CLLocationCoordinate2D
        if searchService.annotations.count > 0 {
            centerCoordinate = searchService.annotations.last!.coordinate
        } else {
            centerCoordinate = userLocation
        }
        
        
        // Region determines how wide of a search area should occur from the user's location
        let region = MKCoordinateRegion(
            center: userLocation,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        searchService.setRegion(region)
                
        return ZStack {
            MapView(centerCoordinate: centerCoordinate,
                    annotations: searchService.annotations)
            Text("\(centerCoordinate.latitude), \(centerCoordinate.longitude)")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(4)
            .onTapGesture {
                self.showingSearch.toggle()
            }.sheet(isPresented: $showingSearch) {
                // FIXME: Presumably a bug in Xcode <=11.6 where we have to pass the environmentObject for sheet views.
                SearchView(showingSearch: self.$showingSearch).environmentObject(self.searchService)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SearchService())
    }
}
