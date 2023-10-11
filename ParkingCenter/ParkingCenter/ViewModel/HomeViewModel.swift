//
//  HomeViewModel.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import CoreLocation
import MapKit

protocol MapViewDelegate {
    func setRegion(pRegion: MKCoordinateRegion)
    func setAnnotation(annotation: MKPointAnnotation)
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

final class HomeViewModel {
    let userLocation = UserLocation()
    let parkingLotManager = ParkingLotManager()
    let coordToRegionManager = RegionMananger()
    var parkingLotData: ParkingLot?
    var didMoveToInitialLocation: Bool = false
    var mapViewDelegate: MapViewDelegate?
    var currentDistrict: String = "Default" {
        didSet {
            // 주차장 정보 불러오기 + 핀찍기
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
    
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span: Double,
                       title strTitle: String,
                       subtitle strSubTitle:String) {
        let annotation = MKPointAnnotation()

        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle

        mapViewDelegate?.setAnnotation(annotation: annotation)
    }
}
