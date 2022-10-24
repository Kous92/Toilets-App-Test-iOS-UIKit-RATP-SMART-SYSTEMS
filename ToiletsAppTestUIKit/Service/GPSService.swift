//
//  GPSService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 19/10/2022.
//

import Foundation
import CoreLocation

final class GPSService: NSObject {
    static let shared = GPSService()
    
    private var actualPosition: (x: Double, y: Double)?
    private var availableLocationService = false
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            availableLocationService = true
        } else {
            print("Service de localisation indisponible")
            availableLocationService = false
        }
    }
    
    func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("L'accès au service de localisation est restreint par le contrôle parental.")
        case .denied:
            print("Vous avez refusé l'accès au service de localisation. Merci de l'autoriser en allant dans Réglages > Confidentialité > Service de localisation > SuperNews.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("OK: la permission est accordée")
            break
        @unknown default:
            break
        }
    }
    
    func getActualPosition() -> CLLocation? {
        guard let actualPosition else {
            return nil
        }
        
        print("Position actuelle: \(CLLocation(latitude: actualPosition.y, longitude: actualPosition.x))")
        return CLLocation(latitude: actualPosition.y, longitude: actualPosition.x)
    }
}

extension GPSService: CLLocationManagerDelegate {
    func fetchLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        let x = Double(location.coordinate.longitude)
        let y = Double(location.coordinate.latitude)
        print(String(format: "Longitude (x) = %.7f", x))
        print(String(format: "Latitude (y) = %.7f", y))
        actualPosition = (x: x, y: y)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationServices()
        checkLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
