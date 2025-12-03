//
//  TrackerDemo.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 26/11/25.
//

import Foundation
import Smart1SDK_iOS
import CoreLocation

class TrackerDemo : Smart1TrackerDataProvider {
    private let locationManager : LocationManager = LocationManager()
    
    private var currentLocation : CoordinatesData? = nil
    private var isRunning       : Bool = false
    
    
    init(
        autoStart : Bool = false
    ) {
        locationManager.onLocationUpdate = { [weak self] location in
            self?.currentLocation = CoordinatesData(
                latitude  : location.coordinate.latitude,
                longitude : location.coordinate.longitude
            )
        }
        if autoStart {
            self.start()
        }
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTracking()
    }

    func stop() {
        isRunning = false
        stopTracking()
        locationManager.stopLocationUpdates()
    }
    
    func isAlreadyRunning() -> Bool {
        return self.isRunning
    }
    
    private func startTracking() {
        let config = Smart1TrackerConfig(
            reportTrackingTimeIntervalInMillis                   : 20_000,
            inOutPortOnActiveOrderValidationTimeIntervalInMillis : 20_000,
            skipReportTrackingIfGPSIsDisabled                    : false
        )
        Smart1Tracker.start(
            config           : config,
            provider         : self,
            onGettingInPort  : { portId in
                print("Getting in on the port with id \(portId)")
                /* TODO
                * ️ Important - Data Synchronization:
                *
                *  When port entry/exit events are detected, the server may automatically update the schedule of the active order.
                *  It is strongly recommended to refresh your app's local data (orders, schedules, ports, etc.) when these callbacks are triggered to maintain synchronization with the API.
                *
                * Best Practice:
                *  Implement a single source of truth pattern using a local database.
                *  When port events trigger data updates, update this centralized store and let reactive observers (e.g., Flow collectors, LiveData) automatically propagate changes to all UI components.
                * */
            },
            onGettingOutPort : { portId in
                print("Getting out of the port with id \(portId)")
                /* TODO
                * ️ Important - Data Synchronization:
                *
                *  When port entry/exit events are detected, the server may automatically update the schedule of the active order.
                *  It is strongly recommended to refresh your app's local data (orders, schedules, ports, etc.) when these callbacks are triggered to maintain synchronization with the API.
                *
                * Best Practice:
                *  Implement a single source of truth pattern using a local database.
                *  When port events trigger data updates, update this centralized store and let reactive observers (e.g., Flow collectors, LiveData) automatically propagate changes to all UI components.
                * */
            },
            onLog            : { level, processType, message in
                // Optional: Log tracker events
                let tag = switch processType {
                case .tracking:
                    "Smart1Tracker - Tracking"
                case .portValidation:
                    "Smart1Tracker - In/Out Port Validation"
                case .unknown:
                    "Smart1Tracker - Unknown"
                default:
                    "Smart1Tracker"
                }
                switch level {
                case .info:
                    print("[\(tag)] INFO: \(message)")
                case .warning:
                    print("[\(tag)] WARNING: \(message)")
                case .error:
                    print("[\(tag)] ERROR: \(message)")
                }
            }
        )
    }
    private func stopTracking() {
        Smart1Tracker.stop()
    }
    
    /// Start Smart1TrackerDataProvider Functions
    
    func getLastLocation() -> CoordinatesData? {
        // Return current location from your location provider
        // For example, using CoreLocation
        if let location = self.currentLocation {
            return location
        }
        return nil
    }
    
    func getCompanyId() -> Int64? {
        return nil
    }
    
    /// End Smart1TrackerDataProvider Functions
}
