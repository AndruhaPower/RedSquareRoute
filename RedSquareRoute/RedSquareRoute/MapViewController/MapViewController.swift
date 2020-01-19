//
//  MapViewController.swift
//  RedSquareRoute
//
//  Created by Andrew on 18/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController {
    
    let mapView = GoogleMapView()
    let googleService = GoogleService()
    var currentlocation: CLLocation?
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.checkLocationServices()
    }
    
    private func setupView() {
        self.mapView.routeButton.addTarget(self, action:  #selector(self.fetchRoute), for: .touchUpInside)
        self.mapView.getLocationButton.addTarget(self, action: #selector(self.updateLocation), for: .touchUpInside)
        self.view = self.mapView
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            self.setupLocationManager()
            self.checkLocationAuthorization()
        }
    }
    
    private func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            self.mapView.map.isMyLocationEnabled = true
            self.centerView()
            self.locationManager.startUpdatingLocation()
        case .denied:
            self.presentAlert(with: "Access Denied", message: "Please allow location services at Setings > Privacy > Location Services to Continue")
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.presentAlert(with: "Access Denied", message: "Location Services are restriced")
        default :
            break
        }
    }
    
    private func centerView() {
        if let location = locationManager.location?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: Constants.zoom)
            self.mapView.map.camera = camera
        }
    }
    
    private func drawPath(from polyStr: String) {
        let path = GMSPath(fromEncodedPath: polyStr)
        let marker = self.setupMarker(with: "Красная площадь", and: "Москва")
        DispatchQueue.main.async { [weak self] in
            guard let path = path else { return }
            let polyline = GMSPolyline(path: path)
            let bounds = GMSCoordinateBounds(path: path)
            polyline.strokeWidth = 5.0
            polyline.strokeColor = .systemBlue
            polyline.map = self?.mapView.map
            self?.mapView.map.animate(with: GMSCameraUpdate.fit(bounds))
            marker.position = Constants.redSquareLocation
        }
    }
    
    private func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionOne = UIAlertAction(title: "Close", style: .destructive, handler: { _ in
            self.mapView.map.animate(toLocation: Constants.redSquareLocation)
            self.mapView.map.animate(toZoom: Constants.zoom)
            let marker = self.setupMarker(with: "Красная площадь", and: "Москва")
            marker.position = Constants.redSquareLocation
        })
        
        alert.addAction(alertActionOne)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func fetchRoute() {
        guard let location = self.currentlocation else { print("location not determined for Fetching"); return }
        self.googleService.fetchRoute(from: location.coordinate, to: Constants.redSquareLocation) { [weak self] (route) in
            self?.drawPath(from: route)
        }
    }
    
    @objc func updateLocation() {
        guard let location = self.currentlocation else { print("location not determined for Update"); return }
        let marker = self.setupMarker(with: "Вы", and: "Текущее местоположение")
        marker.position = location.coordinate
        self.mapView.map.animate(toLocation: location.coordinate)
        self.mapView.map.animate(toZoom: Constants.zoom)
    }
    
    private func setupMarker(with title: String, and snippet: String) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = title
        marker.snippet = snippet
        marker.map = self.mapView.map
        return marker
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentlocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}
