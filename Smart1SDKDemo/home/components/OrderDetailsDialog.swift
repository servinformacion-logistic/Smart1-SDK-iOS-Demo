//
//  OrderDetailsDialog.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import SwiftUI
import Smart1SDK_iOS

struct OrderDetailsDialog: View {
    var data         : OrderContainer
    let onStateClick : (OrderContainer) -> Void
    init(
        data         : OrderContainer,
        onStateClick : @escaping (OrderContainer) -> Void
    ) {
        self.data = data
        self.onStateClick = onStateClick
    }
    var body: some View {
        VScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 4)
                    .padding(.bottom, 12)
                    .padding(.top, 8)
                Text(
                    "Order #\(data.order.id)"
                )
                .foregroundColor(.accentColor)
                .font(.title.bold())
                OrderStatusViewer(
                    orderState: data.order.state,
                    onClick: {
                        onStateClick(data)
                    }
                ).padding(.bottom, 16)
                RouteInfoContainer(
                    data: data
                )
                .padding(.bottom, 16)
                ScheduleResumeContainer(
                    data: data
                )
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
        }
    }
}

struct RouteInfoContainer : View {
    var data : OrderContainer
    var body: some View {
        let routeInfo = data.route
        return AnyView(
            VStack(alignment: .center) {
                HStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    Text(
                        "Route info"
                    )
                    .foregroundColor(.accentColor)
                    .font(.title3.bold())
                        .padding(.horizontal, 2)
                        .fixedSize()
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                
                RouteInfoDataChips(data: routeInfo)
            }
        )
    }
}

struct RouteInfoDataChips : View {
    var data : Route
    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack {
                RightIconText(
                    text: "\(data.type)",
                    icon: Icons().resourceIcon("ic_route"),
                    textColor: .black.opacity(0.7),
                    textFont: .body,
                    iconColor: .black.opacity(0.7),
                    iconSize: 18
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
                RightIconText(
                    text: "\(data.totalDistance) \(data.distanceUnit)",
                    icon: Icons().resourceIcon("ic_distance"),
                    textColor: .black.opacity(0.7),
                    textFont: .body,
                    iconColor: .black.opacity(0.7),
                    iconSize: 18
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
                RightIconText(
                    text: data.totalDuration,
                    icon: Icons().resourceIcon("ic_clock"),
                    textColor: .black.opacity(0.7),
                    textFont: .body,
                    iconColor: .black.opacity(0.7),
                    iconSize: 18
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
            }.fixedSize()
        }
    }
}

struct ScheduleResumeContainer : View {
    var data : OrderContainer
    var body: some View {
        return VStack(alignment: .center) {
            HStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text(
                    "Schedule resume"
                )
                .foregroundColor(.accentColor)
                .font(.title3.bold())
                    .padding(.horizontal, 2)
                    .fixedSize()
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            ForEach(
                data.schedule.sorted {
                    $0.schedule.sequence < $1.schedule.sequence
                },
                id: \.self.schedule.id
            ) { scheduleSingleItem in
                ScheduleItem(
                    data: scheduleSingleItem
                ).listRowInsets(EdgeInsets())
                    .padding(2)
                    .padding(.vertical, 8)
            }.listStyle(.plain)
        }
    }
}
