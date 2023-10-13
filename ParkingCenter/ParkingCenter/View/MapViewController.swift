//
//  MapViewController.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/09.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    private var viewModel: MapViewModel
    
    private var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    private var listButton: UIButton = {
        let button = ListButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(viewModel: MapViewModel) {
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
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(listButton)
        
        listButton.addTarget(self, action: #selector(tappedListButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            listButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            listButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    
    private func setupLocation() {
        viewModel.userLocation.locationManager.delegate = self
        viewModel.mapViewDelegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        
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
}

extension MapViewController {
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
}

extension MapViewController: MapViewDelegate {
    func setRegion(pRegion: MKCoordinateRegion) {
        mapView.setRegion(pRegion, animated: true)
    }
    
    func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func setAnnotation(annotation: MKPointAnnotation) {
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            viewModel.currentLocation = coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard viewModel.didMoveToInitialLocation == true else { return }
        
        viewModel.currentLocation = mapView.centerCoordinate
    }
}
