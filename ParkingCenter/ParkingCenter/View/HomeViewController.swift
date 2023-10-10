//
//  HomeViewController.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import UIKit
import MapKit

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    private var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupConstraints()
        setupLocation()
        receiveData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupLocation() {
        viewModel.userLocation.locationManager.delegate = self
        mapView.showsUserLocation = true
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        let shouldChangeSettings = viewModel.shouldChangeSettings()
        guard shouldChangeSettings == false else {
            showRequestLocationServiceAlert()
            return
        }
        
        viewModel.checkAuthorizationStatus()
    }
    
    func receiveData() {
        let apiKey = Bundle.main.infoDictionary?["ParkingAPIKey"] as! String
        let fileType = "json"
        let serviceName = "GetParkingInfo"
        let startIndex = "1"
        let endIndex = "5"
        let address = "관악구"
        
        let baseURL = "http://openapi.seoul.go.kr:8088"
        let urlString = "\(baseURL)/\(apiKey)/\(fileType)/\(serviceName)/\(startIndex)/\(endIndex)/\(address)"
        
        let url = URL(string: makeStringKoreanEncoded(urlString))!
        
        NetworkingManager().fetchData(url: url) { result in
            switch result {
            case .success(let data):
                self.decodeData(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func decodeData(_ data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(ParkingLot.self, from: data)
            print(decodedData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
    }
}

extension HomeViewController {
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        
        let goSetting = UIAlertAction(
            title: "설정으로 이동",
            style: .destructive
        ) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(
            title: "취소",
            style: .default
        )

        requestLocationServiceAlert.addAction(goSetting)
        requestLocationServiceAlert.addAction(cancel)

        present(requestLocationServiceAlert, animated: true)
    }
    
    func moveLocation(latitudeValue: CLLocationDegrees,
                      longtudeValue: CLLocationDegrees,
                      delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        
        mapView.setRegion(pRegion, animated: true)
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

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            moveLocation(latitudeValue: coordinate.latitude, longtudeValue: coordinate.longitude, delta: 0.01)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let defaultLocation = CLLocationCoordinate2D(latitude: 37.5642135, longitude: 127.0016985)

        moveLocation(latitudeValue: defaultLocation.latitude, longtudeValue: defaultLocation.longitude, delta: 0.01)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
}
