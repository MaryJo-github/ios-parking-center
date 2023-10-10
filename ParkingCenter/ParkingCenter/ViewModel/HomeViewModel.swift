//
//  HomeViewModel.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import CoreLocation

final class HomeViewModel {
    let userLocation = UserLocation()
    
    func shouldChangeSettings() -> Bool {
        switch userLocation.authorizationStatus {
            case .denied, .restricted:
                return true
            default:
                return false
        }
    }
    
    func checkAuthorizationStatus() {
        switch userLocation.authorizationStatus {
            case .notDetermined:
                userLocation.requestAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                userLocation.requestLocation()
            default:
                fatalError("Invalid Authorization Status")
        }
    }
}
