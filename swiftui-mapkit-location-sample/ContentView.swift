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
    var body: some View {
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        return ZStack {
            MapView()
            Text("\(coordinate.latitude), \(coordinate.longitude)")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
