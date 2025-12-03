//
//  HomeState.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 21/11/25.
//

import Smart1SDK_iOS

struct HomeState {
    var isLoading             : Bool = false
    var currentLoadingMsg     : String? = nil
    var isTrackerEnabled      : Bool = false
    var orders                : [OrderContainer] = []
    var isShowingOrderPicker  : Bool = false
    var isShowingPortDetails  : Bool = false
    var isShowingOrderDetails : Bool = false
    var selectedOrder         : OrderContainer? = nil
    var selectedPort          : Port? = nil
    var polylineCoordinates   : [[CoordinatesData]] = []
    var ports                 : [Port] = []
}
