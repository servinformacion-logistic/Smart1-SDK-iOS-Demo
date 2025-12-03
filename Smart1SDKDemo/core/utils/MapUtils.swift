//
//  MapUtils.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import Foundation
import Smart1SDK_iOS
import GoogleMaps

extension CoordinatesData {
    func fromCoordinatesDataToCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
}

extension [CoordinatesData] {
    func fromCoordinatesDataToGMSCameraUpdate(
        padding : CGFloat = 80
    ) -> GMSCameraUpdate {
        var bounds = GMSCoordinateBounds()
        for coordinate in self {
            bounds = bounds.includingCoordinate(coordinate.fromCoordinatesDataToCLLocationCoordinate2D())
        }
        return GMSCameraUpdate.fit(bounds, withPadding: padding)
    }
}

extension [CLLocationCoordinate2D] {
    func fromCLLocationCoordinate2DToGMSCameraUpdate(
        padding : CGFloat = 80
    ) -> GMSCameraUpdate {
        var bounds = GMSCoordinateBounds()
        for coordinate in self {
            bounds = bounds.includingCoordinate(coordinate)
        }
        return GMSCameraUpdate.fit(bounds, withPadding: padding)
    }
}

extension GoogleMarker {
    func fromGoogleMarkerToCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
    func fromGoogleMarkerToGMSMarker(
        groundAnchor : CGPoint = CGPoint(x: 0.5, y: 0.2)
    ) -> GMSMarker {
        let gmsMarker = GMSMarker()
        gmsMarker.position = self.fromGoogleMarkerToCLLocationCoordinate2D()
        gmsMarker.icon = self.icon
        gmsMarker.groundAnchor = groundAnchor
        gmsMarker.title = self.title
        gmsMarker.userData = self.userData
        return gmsMarker
    }
}

extension Smart1SDK_iOS.Port {
    func fromPortDataToGoogleMarker(
        portSequenceNumber : Int
    ) -> GoogleMarker {
        return GoogleMarker(
            latitude  : self.latitude,
            longitude : self.longitude,
            title     : self.name,
            userData  : self
        )
    }
}

extension [Smart1SDK_iOS.Port] {
    func fromPortDataToGoogleMarker() -> [GoogleMarker] {
        var googleMarkers: [GoogleMarker] = []
        var markerCount = 1
        for port in self {
            googleMarkers.append(port.fromPortDataToGoogleMarker(portSequenceNumber: markerCount))
            markerCount += 1
        }
        return googleMarkers
    }
}

extension [CoordinatesData] {
    func fromCoordinatesDataToGooglePolyline() -> GooglePolyline {
        return GooglePolyline(
            coordinates: self
        )
    }
}

extension [[CoordinatesData]] {
    func fromCoordinatesDataToGooglePolyline() -> [GooglePolyline] {
        return self.map { polyline in
            polyline.fromCoordinatesDataToGooglePolyline()
        }
    }
}

extension GooglePolyline {
    func fromGooglePolylineToGMSPolyline() -> GMSPolyline {
        let path = GMSMutablePath()
        for polylineCoordinates in self.coordinates {
            path.add(polylineCoordinates.fromCoordinatesDataToCLLocationCoordinate2D())
        }
        let gmsPolyline = GMSPolyline(path: path)
        gmsPolyline.strokeColor = self.strokeColor
        gmsPolyline.strokeWidth = self.strokeWidth
        return gmsPolyline
    }
}

extension [GooglePolyline] {
    func fromGooglePolylineToGMSPolyline() -> [GMSPolyline] {
        return self.map { polyline in
            polyline.fromGooglePolylineToGMSPolyline()
        }
    }
}
