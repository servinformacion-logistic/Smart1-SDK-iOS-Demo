//
//  HomeEvent.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 21/11/25.
//

import Smart1SDK_iOS

enum HomeEvent {
    case startTracker
    case notifyNewOrderInProgressToTracker
    case stopTracker
    case goToAppSettings
    case openCloseOrderPicker(
        shouldOpen : Bool
    )
    case openCloseOrderDetails(
        shouldOpen : Bool
    )
    case openClosePortDetails(
        shouldOpen : Bool
    )
    case updateMapCamera(
        coordinates : [CoordinatesData]
    )
    case error(
        msg : String
    )
}
