//
//  PortDetailsDialog.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import SwiftUI
import Smart1SDK_iOS

struct PortDetailsDialog: View {
    var data  : Smart1SDK_iOS.Port
    var order : OrderContainer
    init(
        data: Smart1SDK_iOS.Port,
        order: OrderContainer
    ) {
        self.data = data
        self.order = order
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
                    data.name
                )
                .foregroundColor(.accentColor)
                    .font(.title.bold())
                if !data.description.isEmpty {
                    Text(
                        data.description
                    )
                    .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 8)
                }
                PortInfoDataChips(data: data)
                    .padding(.bottom, 16)
                let schedule = order.schedule.filter {
                    $0.port.id == data.id
                }.sorted {
                    $0.schedule.sequence < $1.schedule.sequence
                }
                if !schedule.isEmpty {
                    SchedulePortResumeContainer(
                        data: schedule
                    )
                }
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
        }
    }
}

struct PortInfoDataChips : View {
    var data : Smart1SDK_iOS.Port
    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack(
                alignment: .center
            ) {
                RightIconText(
                    text: data.city,
                    icon: Icons().resourceIcon("ic_city"),
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
                    text: data.address,
                    icon: Icons().systemIcon("mappin.and.ellipse"),
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
                    text: data.identification,
                    icon: Icons().resourceIcon("ic_card"),
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

struct SchedulePortResumeContainer : View {
    var data : [ScheduleContainer]
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
                data,
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
