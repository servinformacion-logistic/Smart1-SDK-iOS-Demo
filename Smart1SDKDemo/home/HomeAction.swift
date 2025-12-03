//
//  HomeAction.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 21/11/25.
//

import Smart1SDK_iOS

enum HomeAction {
    case onStart(
        isTrackerRunning : Bool
    )
    case onStartOrStopTracker(
        isTrackerRunning : Bool
    )
    case onSettingsClicked
    case onRefreshClicked
    case onSelectOrderClicked
    case onOrderSelected(
        order : OrderContainer
    )
    case onOrderInfoClicked(
        order : OrderContainer
    )
    case onSomePortClicked(
        port : Port
    )
    case onSelectOrderDismissed
    case onPortDetailsDismissed
    case onOrderDetailsDismissed
    case onStartOrder(
        order : OrderContainer
    )
}
