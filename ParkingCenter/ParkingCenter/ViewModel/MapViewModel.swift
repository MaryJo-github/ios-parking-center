//
//  HomeViewModel.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import CoreLocation
import MapKit

final class MapViewModel {
    let userLocation = UserLocation()
    let parkingLotManager = ParkingLotManager()
    let regionManager = RegionManager()
    var didMoveToInitialLocation: Bool = false
    var mapViewDelegate: MapViewDelegate?
    var currentDistrict: String?

    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5642135, longitude: 127.0016985) {
        didSet {
            if currentLocation == oldValue { return }
            
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
    
    private func fetchParkingLotData(district: String) {
        parkingLotManager.receiveData(district: district) { [weak self] result in
            switch result {
            case .success(let data):
                self?.setAnnotations(informations: data.getParkingInfo.information)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func checkNeedToLoadParkingInfo() {
        regionManager.receiveData(coordinate: currentLocation) { [weak self] result in
            switch result {
            case .success(let data):
                guard data.documents.first?.city == "서울특별시",
                      let district = data.documents.first?.district else {
                    return
                }
                
                guard self?.currentDistrict != district else {
                    return
                }
                
                self?.currentDistrict = district
                self?.fetchParkingLotData(district: district)
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
    
    func setAnnotations(informations: [ParkingInformation]?) {
        mapViewDelegate?.removeAnnotations()

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
    
    func findInformationsBy(name: String) -> [ParkingInformation]? {
        guard let informations = parkingLotManager.informations else {
            return nil
        }
        
        return informations.filter { information in
            information.name == name
        }
    }
}
