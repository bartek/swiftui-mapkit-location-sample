//
//  MapView.swift
//  swiftui-mapkit-location-sample
//
//  Created by Bartek Ciszkowski on 2020-08-21.
//  Copyright © 2020 Bartek Ciszkowski. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame:  UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

/*
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
*/
