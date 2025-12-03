//
//  LocationPermissionManager.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import Foundation
import CoreLocation

class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 10
        //
        if (CLLocationManager().authorizationStatus == .denied) {
            OSUrlUtils().openSystemSettings()
        } else {
            if (CLLocationManager().authorizationStatus == .authorizedWhenInUse) {
                OSUrlUtils().openSystemSettings()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let authorizedAlways = CLLocationManager().authorizationStatus == .authorizedAlways
        let authorizedWhenInUse = CLLocationManager().authorizationStatus == .authorizedWhenInUse
        let restricted = CLLocationManager().authorizationStatus == .restricted
        let denied = CLLocationManager().authorizationStatus == .denied
        let notDetermined = CLLocationManager().authorizationStatus == .notDetermined
        if (
            authorizedWhenInUse && !authorizedAlways
        ) {
            locationManager.requestAlwaysAuthorization()
        }
        onAuthorizationChange?(status)
    }
    
    private func statusString(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        @unknown default: return "unknown"
        }
    }
}
