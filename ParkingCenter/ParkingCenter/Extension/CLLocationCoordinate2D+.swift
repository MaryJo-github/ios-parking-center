//
//  CLLocationCoordinate2D+.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/12.
//

import CoreLocation

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
