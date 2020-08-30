//
//  LocationManager.swift
//  swiftui-mapkit-location-sample
//
//  Created by Bartek Ciszkowski on 2020-08-21.
//  Copyright © 2020 Bartek Ciszkowski. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
