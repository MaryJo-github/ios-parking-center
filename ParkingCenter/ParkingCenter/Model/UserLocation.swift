//
//  UserLocation.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import CoreLocation

final class UserLocation {
    
    let locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}
