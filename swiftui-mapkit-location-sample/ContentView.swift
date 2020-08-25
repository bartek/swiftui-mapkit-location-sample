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
    @EnvironmentObject var locationService: LocationService
    
    @State var showingSearch = false;
    
    let regionRadius: CLLocationDistance = 1000
    
    var body: some View {
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        // Whenever the MapView is updated (e.g. new location), the region will be reset.
        locationService.setRegion(region)
        
        return ZStack {
            MapView()
            Text("\(coordinate.latitude), \(coordinate.longitude)")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(4)
            .onTapGesture {
                self.showingSearch.toggle()
            }.sheet(isPresented: $showingSearch) {
                // FIXME: Presumably a bug in Xcode <=11.6 where we have to pass the environmentObject for sheet views.
                SearchView().environmentObject(self.locationService)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(LocationService())
    }
}
