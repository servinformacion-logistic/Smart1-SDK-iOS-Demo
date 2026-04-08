//
//  HomeScreen.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import SwiftUI
import Smart1SDK_iOS
import GoogleMaps

struct HomeScreen: View {
    @ObservedObject var viewModel : HomeViewModel
    @State private var message : String = ""
    @State private var showMessage = false
    @State private var cameraUpdate: GMSCameraUpdate = [
        CLLocationCoordinate2D(
            latitude: 4.672438,
            longitude: -74.063772
        )
    ].fromCLLocationCoordinate2DToGMSCameraUpdate()
    @State private var isShowingOrderPicker : Bool = false
    @State private var isShowingOrderDetails : Bool = false
    @State private var isShowingPortDetails : Bool = false
    let locationPermissionManager : LocationPermissionManager = LocationPermissionManager()
    init() {
        self.viewModel = HomeViewModel()
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Toolbar(
                    state    : viewModel.state,
                    onAction : viewModel.onAction(_:)
                )
                Header(
                    state    : viewModel.state,
                    onAction : viewModel.onAction(_:)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                ZStack {
                    GoogleMapView(
                        cameraUpdate    : cameraUpdate,
                        markers         : viewModel.state.ports.fromPortDataToGoogleMarker(),
                        polylines       : viewModel.state.polylineCoordinates.fromCoordinatesDataToGooglePolyline(),
                        onMarkerClicked : { marker in
                            if let port = marker.userData as? Smart1SDK_iOS.Port {
                                viewModel.onAction(HomeAction.onSomePortClicked(port: port))
                            }
                        }
                    )
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(
                        alignment: .leading
                    ) {
                        HStack {
                            SelectableItem(
                                text: "Select a order",
                                onClick: {
                                    viewModel.onAction(HomeAction.onSelectOrderClicked)
                                }
                            ).padding(8)
                                .padding(.leading, 4)
                            Spacer()
                        }
                        Spacer()
                    }.padding(.top, 4)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            LoadingDialog(
                isOpen: viewModel.state.isLoading,
                onDismiss: { /**Nothing*/ },
                text: viewModel.state.currentLoadingMsg
            )
        }.onAppear {
            viewModel.onAction(HomeAction.onStart(isTrackerRunning: TrackerDemoSt.isAlreadyRunning()))
            locationPermissionManager.requestAuthorization()
        }.sheet(
            isPresented: $isShowingOrderPicker,
            onDismiss: {
                viewModel.onAction(HomeAction.onSelectOrderDismissed)
            }
        ) {
            OrderPickerDialog(
                data            : viewModel.state.orders,
                onOrderSelected : { orderSelected in
                    viewModel.onAction(HomeAction.onOrderSelected(order: orderSelected))
                }
            )
        }.sheet(
            isPresented: $isShowingOrderDetails,
            onDismiss: {
                viewModel.onAction(HomeAction.onOrderDetailsDismissed)
            }
        ) {
            if let order = viewModel.state.selectedOrder {
                OrderDetailsDialog(
                    data         : order,
                    onStateClick : { orderClicked in
                        if (orderClicked.order.state == OrderState.assigned) {
                            viewModel.onAction(HomeAction.onStartOrder(order: orderClicked))
                        }
                    }
                )
            }
        }.sheet(
            isPresented: $isShowingPortDetails,
            onDismiss: {
                viewModel.onAction(HomeAction.onPortDetailsDismissed)
            }
        ) {
            if let port = viewModel.state.selectedPort {
                if let order = viewModel.state.selectedOrder {
                    PortDetailsDialog(
                        data: port,
                        order: order
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(viewModel.events) { event in
                switch event {
                case .startTracker:
                    TrackerDemoSt.start()
                case .notifyNewOrderInProgressToTracker:
                    TrackerDemoSt.notifyNewOrderInProgress()
                case .stopTracker:
                    TrackerDemoSt.stop()
                case .goToAppSettings:
                    OSUrlUtils().openSystemSettings()
                case .openCloseOrderPicker(
                    let shouldOpen
                ):
                    isShowingOrderPicker = shouldOpen
                case .openCloseOrderDetails(
                    let shouldOpen
                ):
                    isShowingOrderDetails = shouldOpen
                case .openClosePortDetails(
                    let shouldOpen
                ):
                    isShowingPortDetails = shouldOpen
                case .updateMapCamera(
                    let coordinates
                ):
                    cameraUpdate = coordinates.fromCoordinatesDataToGMSCameraUpdate()
                case .error(
                    let error
                ):
                    message = "\(error)"
                    showMessage.toggle()
                }
        }.onReceive(TrackerDemoSt.onGettingInOrOutPortEventPublisher) { _ in
            viewModel.onAction(.onRefreshClicked)
        }.alert(
                isPresented: $showMessage
            ) {
                Alert(
                    title: Text(message),
                    dismissButton: .default(Text("Ok"))
                )
            }
    }
}

private struct Header : View {
    let state    : HomeState
    let onAction : (HomeAction) -> Void
    var body: some View {
        let title = if let order = state.selectedOrder {
            "Order #\(order.order.id)"
        } else {
            "Select an order to visualize"
        }
        HStack(
            alignment: .center
        ) {
            Text(title)
                .foregroundColor(.primary)
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
            if let order = state.selectedOrder {
                Button(action: {
                    onAction(.onOrderInfoClicked(order: order))
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 8)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct Toolbar : View {
    let state    : HomeState
    let onAction : (HomeAction) -> Void
    var body: some View {
        HStack {
            Icons().resourceImage("app_logo")
                .resizable()
                .frame(width: 36, height: 36)
            Text("S1 Demo")
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            Spacer()
            Button(action: {
                onAction(.onStartOrStopTracker(isTrackerRunning: TrackerDemoSt.isAlreadyRunning()))
            }) {
                Text(state.isTrackerEnabled ? "Turn Off Tracker" : "Turn On Tracker")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(state.isTrackerEnabled ? Color.red : Color.green)
                    .cornerRadius(8)
            }
            Button(action: {
                onAction(.onSettingsClicked)
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.leading, 8)
            Button(action: {
                onAction(.onRefreshClicked)
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.accentColor)
    }
}
