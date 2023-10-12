//
//  HomeViewModel.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import CoreLocation
import MapKit

final class HomeViewModel {
    let userLocation = UserLocation()
    let parkingLotManager = ParkingLotManager()
    let coordToRegionManager = RegionMananger()
    var didMoveToInitialLocation: Bool = false
    var mapViewDelegate: MapViewDelegate?
    
    var currentDistrict: String = "Default" {
        didSet {
            fetchParkingLotData()
            print(currentDistrict)
        }
    }
    
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5642135, longitude: 127.0016985) {
        didSet {
            if currentLocation == oldValue { return }
            print("\(currentLocation.latitude)\n\(currentLocation.longitude)")
            
            moveLocation(delta: 0.01)
            checkNeedToLoadParkingInfo()
        }
    }
    
    var parkingLotData: ParkingLot? {
        didSet {
            setAnnotations()
        }
    }
    
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
    
    private func fetchParkingLotData() {
        parkingLotManager.receiveData(district: currentDistrict) { [weak self] result in
            switch result {
            case .success(let data):
                self?.parkingLotData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func checkNeedToLoadParkingInfo() {
        coordToRegionManager.receiveData(coordinate: currentLocation) { [weak self] result in
            switch result {
            case .success(let data):
                guard data.documents.first?.city == "서울특별시" else {
                    return
                }
                
                guard let district = data.documents.first?.district,
                      self?.currentDistrict != district else {
                    return
                }
                
                self?.currentDistrict = district
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func moveLocation(delta span: Double) {
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: currentLocation, span: pSpanValue)
        
        mapViewDelegate?.setRegion(pRegion: pRegion)
        
        if didMoveToInitialLocation == false {
            didMoveToInitialLocation.toggle()
        }
    }
    
    func setAnnotations() {
        let informations = parkingLotData?.getParkingInfo.information
        
        informations?.forEach { information in
            let coordinate = CLLocationCoordinate2D(latitude: information.latitude,
                                                    longitude: information.longitude)
            setAnnotation(coordinate: coordinate,
                          title: information.name,
                          subtitle: information.typeName)
        }
    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D,
                       title strTitle: String,
                       subtitle strSubTitle:String) {
        let annotation = MKPointAnnotation()

        annotation.coordinate = coordinate
        annotation.title = strTitle
        annotation.subtitle = strSubTitle

        mapViewDelegate?.setAnnotation(annotation: annotation)
    }
}
