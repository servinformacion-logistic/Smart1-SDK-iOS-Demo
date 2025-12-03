//
//  CoordinatesUtils.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import Smart1SDK_iOS

class CoordinatesUtils {
    /// Decodes a polyline string into a list of coordinates.
    ///
    /// - Parameters:
    ///   - encodedPolyline: The encoded polyline string
    ///   - inverseCoordinates: Whether to inverse the coordinates (default: false)
    /// - Returns: The list of coordinates
    func decodePolyline(
        encodedPolyline    : String,
        inverseCoordinates : Bool = false
    ) -> [CoordinatesData] {
        do {
            if encodedPolyline.isEmpty {
                return []
            }
            
            var coordinates: [CoordinatesData] = []
            var index = 0
            var lat = 0
            var lng = 0
            
            let polylineChars = Array(encodedPolyline)
            
            while index < polylineChars.count {
                var b: Int
                var shift = 0
                var result = 0
                
                repeat {
                    b = Int(polylineChars[index].asciiValue ?? 0) - 63
                    index += 1
                    result = result | ((b & 0x1f) << shift)
                    shift += 5
                } while b >= 0x20
                
                let dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
                lat += dlat
                
                shift = 0
                result = 0
                
                repeat {
                    b = Int(polylineChars[index].asciiValue ?? 0) - 63
                    index += 1
                    result = result | ((b & 0x1f) << shift)
                    shift += 5
                } while b >= 0x20
                
                let dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
                lng += dlng
                
                if inverseCoordinates {
                    coordinates.append(
                        CoordinatesData(
                            latitude  : Double(lng) / 1e5,
                            longitude : Double(lat) / 1e5
                        )
                    )
                } else {
                    coordinates.append(
                        CoordinatesData(
                            latitude  : Double(lat) / 1e5,
                            longitude : Double(lng) / 1e5
                        )
                    )
                }
            }
            
            return coordinates
        } catch {
            return []
        }
    }
}
