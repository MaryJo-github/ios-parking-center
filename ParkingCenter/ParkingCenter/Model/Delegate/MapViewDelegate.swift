//
//  MapViewDelegate.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/12.
//

import MapKit

protocol MapViewDelegate: AnyObject {
    func setRegion(pRegion: MKCoordinateRegion)
    func removeAnnotations()
    func setAnnotation(annotation: MKPointAnnotation)
}
