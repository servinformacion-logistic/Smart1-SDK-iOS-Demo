//
//  HomeViewModel.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 21/11/25.
//

import Combine
import Smart1SDK_iOS

extension HomeScreen {
    @MainActor
    class HomeViewModel: ObservableObject {
        
        @Published private(set) var state = HomeState()
        
        private let eventSubject = PassthroughSubject<HomeEvent, Never>()
        var events: AnyPublisher<HomeEvent, Never> {
            eventSubject.eraseToAnyPublisher()
        }
        
        private let getOrdersFromSDK = GetAndSearchOrdersByPage()
        private let getScheduleFromSDK = GetAndSearchScheduleByPage()
        private let getPortsFromSDK = GetAndSearchPortsByPage()
        private let getDocksFromSDK = GetAndSearchDocksByPage()
        private let getRoutesFromSDK = GetAndSearchRoutesByPage()
        private let updateOrderState = UpdateOrderState()
        
        init () {
            Task {
                await handleOnRefreshData(forceRefresh: true)
            }
        }
        
        func onAction(_ action: HomeAction) {
            switch action {
            case .onStart(let isTrackerRunning):
                state.isTrackerEnabled = isTrackerRunning
                
            case .onStartOrStopTracker(let isTrackerRunning):
                Task {
                    state.isTrackerEnabled = !isTrackerRunning
                    if isTrackerRunning {
                        Task {
                            await LogoutAndFinishSession().execute()
                        }
                        eventSubject.send(.stopTracker)
                    } else {
                        StartSDKUtils().startSDK()
                        eventSubject.send(.startTracker)
                    }
                }
                
            case .onRefreshClicked:
                Task {
                    await handleOnRefreshData(forceRefresh: true)
                }
                
            case .onSettingsClicked:
                eventSubject.send(.goToAppSettings)
                
            case .onSelectOrderClicked:
                handleSelectOrderClicked()
                
            case .onOrderSelected(let order):
                Task {
                    await handleOrderSelected(order: order)
                }
                
            case .onOrderInfoClicked(let order):
                handleSeeOrderDetails(order: order)
                
            case .onStartOrder(let order):
                Task {
                    await handleStartOrder(order: order)
                }
                
            case .onSomePortClicked(let port):
                handleOnPortClicked(port: port)
                
            case .onSelectOrderDismissed:
                state.isShowingOrderPicker = false
                eventSubject.send(.openCloseOrderPicker(shouldOpen: false))
                
            case .onOrderDetailsDismissed:
                state.isShowingOrderDetails = false
                eventSubject.send(.openCloseOrderDetails(shouldOpen: false))
                
            case .onPortDetailsDismissed:
                state.isShowingPortDetails = false
                eventSubject.send(.openClosePortDetails(shouldOpen: false))
            }
        }
        
        private func handleOnRefreshData(forceRefresh: Bool = false) async {
            if !forceRefresh && !state.orders.isEmpty {
                return
            }
            
            state.isLoading = true
            state.currentLoadingMsg = "Loading Orders..."
            
            // Load Orders
            let orders = await PaginationUtils.getPaginatedData(
                getData: { page in
                    let res = await self.getOrdersFromSDK.execute(
                        fields : [OrderProperty.id, OrderProperty.routeId, OrderProperty.state],
                        page   : page
                    )
                    switch res {
                    case .success(let data):
                        return data
                    case .failure(let error):
                        print("Error: \(ErrorUtils.toMsg(error: error))")
                        return nil
                    @unknown default:
                        return nil
                    }
                },
                onProgress: { current, total in
                    await MainActor.run {
                        self.state.currentLoadingMsg = "Loading Orders\n [\(current) from \(total)]"
                    }
                }
            )
            
            
            guard !orders.isEmpty else {
                state.isLoading = false
                state.currentLoadingMsg = nil
                eventSubject.send(.error(msg: "No orders found"))
                return
            }
            
            
            state.currentLoadingMsg = "Loading Schedule..."
            
            // Load Schedule
            let schedule = await PaginationUtils.getPaginatedData (
                getData: { page in
                    let res = await self.getScheduleFromSDK.execute(
                        fields: [
                            .id, .orderId, .dockId, .sequence,
                            .stateName, .job, .dateEventInit,
                            .hourEventInit, .dateEventEnd, .hourEventEnd
                        ],
                        filters: ScheduleFilters(
                            orderIds: orders.map { $0.id }
                        ),
                        page: page
                        
                    )
                    switch res {
                    case .success(let data):
                        return data
                    case .failure(let error):
                        print("Error: \(ErrorUtils.toMsg(error: error))")
                        return nil
                    @unknown default:
                        return nil
                    }
                },
                onProgress: { current, total in
                    await MainActor.run {
                        self.state.currentLoadingMsg = "Loading Schedule\n [\(current) from \(total)]"
                    }
                }
            )
            
            guard !schedule.isEmpty else {
                state.isLoading = false
                state.currentLoadingMsg = nil
                let orderIds = orders.map { String($0.id) }.joined(separator: ", ")
                eventSubject.send(.error(msg: "No schedule found for related orders [\(orderIds)]"))
                return
            }
            
            state.currentLoadingMsg = "Loading Docks..."
            
            // Load Docks
            let docks = await PaginationUtils.getPaginatedData(
                getData: { page in
                    let res = await self.getDocksFromSDK.execute(
                        fields: [
                            .id, .name, .pickupTime, .deliveryTime,
                            .portId, .status, .fleet
                        ],
                        filters: DockFilters(
                            ids: schedule.map { $0.dockId }
                        ),
                        page: page
                    )
                    switch res {
                    case .success(let data):
                        return data
                    case .failure(let error):
                        print("Error: \(ErrorUtils.toMsg(error: error))")
                        return nil
                    @unknown default:
                        return nil
                    }
                },
                onProgress: { current, total in
                    await MainActor.run {
                        self.state.currentLoadingMsg = "Loading Docks\n [\(current) from \(total)]"
                    }
                }
            )
            
            guard !docks.isEmpty else {
                state.isLoading = false
                state.currentLoadingMsg = nil
                let dockIds = schedule.map { String($0.dockId) }.joined(separator: ", ")
                eventSubject.send(.error(msg: "No docks found for related schedule [\(dockIds)]"))
                return
            }
            
            state.currentLoadingMsg = "Loading Ports..."
            
            // Load Ports
            let ports = await PaginationUtils.getPaginatedData(
                getData: { page in
                    let res = await self.getPortsFromSDK.execute(
                        fields: [
                            .id, .name, .description, .identification,
                            .country, .department, .city, .address,
                            .latitude, .longitude, .status
                        ],
                        filters: PortFilters(
                            ids: docks.map { $0.portId }
                        ),
                        page: page
                    )
                    switch res {
                    case .success(let data):
                        return data
                    case .failure(let error):
                        print("Error: \(ErrorUtils.toMsg(error: error))")
                        return nil
                    @unknown default:
                        return nil
                    }
                },
                onProgress: { current, total in
                    await MainActor.run {
                        self.state.currentLoadingMsg = "Loading Ports\n [\(current) from \(total)]"
                    }
                }
            )
            
            guard !ports.isEmpty else {
                state.isLoading = false
                state.currentLoadingMsg = nil
                let portIds = docks.map { String($0.portId) }.joined(separator: ", ")
                eventSubject.send(.error(msg: "No ports found for related docks [\(portIds)]"))
                return
            }
            
            state.currentLoadingMsg = "Loading Routes..."
            
            // Load Routes
            let routes = await PaginationUtils.getPaginatedData(
                getData: { page in
                    let res = await self.getRoutesFromSDK.execute(
                        fields: [
                            .id, .name, .description, .type,
                            .distanceUnit, .totalDuration, .totalDistance,
                            .routeInfo, .status
                        ],
                        filters: RouteFilters(
                            ids: orders.map { $0.routeId }
                        ),
                        page: page
                    )
                    switch res {
                    case .success(let data):
                        return data
                    case .failure(let error):
                        print("Error: \(ErrorUtils.toMsg(error: error))")
                        return nil
                    @unknown default:
                        return nil
                    }
                },
                onProgress: { current, total in
                    await MainActor.run {
                        self.state.currentLoadingMsg = "Loading Routes\n [\(current) from \(total)]"
                    }
                }
            )
            
            guard !routes.isEmpty else {
                state.isLoading = false
                state.currentLoadingMsg = nil
                let routeIds = orders.map { String($0.routeId) }.joined(separator: ", ")
                eventSubject.send(.error(msg: "No routes found for related orders [\(routeIds)]"))
                return
            }
            
            state.currentLoadingMsg = "Mapping Data..."
            
            // Map related data
            var ordersWithRelatedData: [OrderContainer] = []
            
            for order in orders {
                var relatedSchedule: [ScheduleContainer] = []
                
                for scheduleItem in schedule.filter({ $0.orderId == order.id }) {
                    guard let relatedDock = docks.first(where: { $0.id == scheduleItem.dockId }) else {
                        continue
                    }
                    guard let relatedPort = ports.first(where: { $0.id == relatedDock.portId }) else {
                        continue
                    }
                    relatedSchedule.append(
                        ScheduleContainer(
                            schedule: scheduleItem,
                            port: relatedPort,
                            dock: relatedDock
                        )
                    )
                }
                
                guard let relatedRoute = routes.first(where: { $0.id == order.routeId }) else {
                    continue
                }
                
                ordersWithRelatedData.append(
                    OrderContainer(
                        order: order,
                        schedule: relatedSchedule,
                        route: relatedRoute
                    )
                )
            }
            let lastSelectedOrder = state.selectedOrder
            if lastSelectedOrder != nil {
                let lastDataOfSelectedOrder = ordersWithRelatedData.first(where: { $0.order.id == lastSelectedOrder!.order.id })
                if let nonNullLastDataOfSelectedOrder = lastDataOfSelectedOrder {
                    await handleOrderSelected(order: nonNullLastDataOfSelectedOrder)
                } else {
                    state.selectedOrder = nil
                    state.polylineCoordinates = []
                    state.ports = []
                    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 sec
                }
            }
            
            state.isLoading = false
            state.currentLoadingMsg = nil
            state.orders = ordersWithRelatedData
        }
        
        private func handleStartOrder(order: OrderContainer) async {
            state.isLoading = true
            state.currentLoadingMsg = "Starting order..."
            
            let result = await updateOrderState.execute(
                orderId   : order.order.id,
                newStatus : .inProgress
            )
            
            switch result {
            case .success:
                eventSubject.send(.notifyNewOrderInProgressToTracker)
                state.orders = state.orders.map { orderItem in
                    if orderItem.order.id == order.order.id {
                        let updatedOrder = OrderContainer(
                            order    : Order(
                                id      : orderItem.order.id,
                                routeId : orderItem.order.routeId,
                                state   : .inProgress
                            ),
                            schedule : orderItem.schedule,
                            route    : orderItem.route
                        )
                        return updatedOrder
                    }
                    return orderItem
                }
                if let previousSelectedOrder = state.selectedOrder {
                    let updatedOrder = OrderContainer(
                        order    : Order(
                            id      : previousSelectedOrder.order.id,
                            routeId : previousSelectedOrder.order.routeId,
                            state   : .inProgress
                        ),
                        schedule : previousSelectedOrder.schedule,
                        route    : previousSelectedOrder.route
                    )
                    state.selectedOrder = updatedOrder
                }
                state.isLoading = false
                state.currentLoadingMsg = nil
            case .failure(let error):
                state.isLoading = false
                state.currentLoadingMsg = nil
                eventSubject.send(.error(msg: ErrorUtils.toMsg(error: error)))
            @unknown default:
                state.isLoading = false
                state.currentLoadingMsg = nil
            }
        }
        
        private func handleSelectOrderClicked() {
            guard !state.orders.isEmpty else {
                eventSubject.send(.error(msg: "No orders found on current session"))
                return
            }
            
            state.isShowingOrderPicker = true
            eventSubject.send(.openCloseOrderPicker(shouldOpen: true))
        }
        
        private func handleOrderSelected(order: OrderContainer) async {
            state.isLoading = true
            state.isShowingOrderPicker = false
            eventSubject.send(.openCloseOrderPicker(shouldOpen: false))
            
            if state.selectedOrder != nil {
                state.selectedOrder = nil
                state.polylineCoordinates = []
                state.ports = []
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 sec
            }
            
            state.isLoading = false
            state.selectedOrder = order
            
            let portsToVisit = order.schedule
                .sorted { $0.schedule.sequence < $1.schedule.sequence }
                .map { $0.port }
                .removingDuplicates(by: \.id)
            
            let routePolyline = order.route.routeInfo
                .sorted { $0.sequence > $1.sequence }
                .map { $0.segmentPolyline }
            
            if !routePolyline.isEmpty {
                var polylineCoordinates: [[CoordinatesData]] = []
                for polyline in routePolyline {
                    polylineCoordinates.append(CoordinatesUtils().decodePolyline(encodedPolyline: polyline))
                }
                
                let flatCoordinates = polylineCoordinates.flatMap { $0 }
                eventSubject.send(.updateMapCamera(coordinates: flatCoordinates))
                state.polylineCoordinates = polylineCoordinates
                state.ports = portsToVisit
            }
        }
        
        private func handleSeeOrderDetails(order: OrderContainer) {
            state.isLoading = false
            state.isShowingOrderDetails = true
            state.selectedOrder = order
            eventSubject.send(.openCloseOrderDetails(shouldOpen: true))
        }
        
        private func handleOnPortClicked(port: Port) {
            state.isShowingPortDetails = true
            state.selectedPort = port
            eventSubject.send(.openClosePortDetails(shouldOpen: true))
        }
    }
}

// MARK: - Helper Extension
extension Array {
    func removingDuplicates<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
