//
//  GoogleMapView.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    var cameraUpdate  : GMSCameraUpdate
    var cameraPadding : CGFloat = 50
    
    var markers         : [GoogleMarker]   = []
    var polylines       : [GooglePolyline] = []
    var onMarkerClicked : ((GoogleMarker) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        mapView.mapType = .hybrid
        mapView.isTrafficEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        mapView.animate(with: cameraUpdate)
        for marker in markers {
            let gmsMarker = marker.fromGoogleMarkerToGMSMarker()
            gmsMarker.map = mapView
        }
        for polyline in polylines {
            let gmsPolyline = polyline.fromGooglePolylineToGMSPolyline()
            gmsPolyline.map = mapView
        }
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView

        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            parent.onMarkerClicked?(GoogleMarker(latitude: 0.0, longitude: 0.0, userData: marker.userData))
            return true
        }
    }
}
