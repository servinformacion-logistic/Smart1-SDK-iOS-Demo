//
//  ScheduleItem.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI
import Smart1SDK_iOS

struct ScheduleItem: View {
    let data : ScheduleContainer
    var body: some View {
        HStack(alignment: .center) {
            CounterText(
                text: "\(data.schedule.sequence)",
                backgroundColor: .secondary,
                textColor: .black.opacity(0.6)
            ).padding(.trailing, 8)
            VStack(alignment: .leading) {
                HStack {
                    Text(
                        "\(data.schedule.job)"
                    )
                    .font(.body.bold())
                    .foregroundColor(.accentColor)
                    Spacer()
                    Text(
                        data.schedule.stateName
                    )
                    .font(.body.bold())
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.tertiary)
                        .cornerRadius(8)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 2)
                }
                HStack(alignment: .bottom) {
                    VStack {
                        RightIconText(
                            text: data.port.name,
                            icon: Icons().resourceIcon("ic_port"),
                            textFont: .body,
                            iconSize: 16,
                            requiresSpacerAtEnd: true
                        )
                        RightIconText(
                            text: data.dock.name,
                            icon: Icons().resourceIcon("ic_dock"),
                            textFont: .body,
                            iconSize: 16,
                            requiresSpacerAtEnd: true

                        )
                        RightIconText(
                            text: data.port.address,
                            icon: Icons().resourceIcon("ic_port"),
                            textFont: .body,
                            iconSize: 16,
                            requiresSpacerAtEnd: true
                        )
                        RightIconText(
                            text: data.port.city,
                            icon: Icons().resourceIcon("ic_city"),
                            textFont: .body,
                            iconSize: 16,
                            requiresSpacerAtEnd: true
                        )
                        RightIconText(
                            text: "\(data.schedule.dateEventInit) \(data.schedule.hourEventInit)",
                            icon: Icons().resourceIcon("ic_init_date"),
                            textFont: .body,
                            iconSize: 16,
                            requiresSpacerAtEnd: true
                        )
                        RightIconText(
                            text:  "\(data.schedule.dateEventEnd) \(data.schedule.hourEventEnd)",
                            icon: Icons().resourceIcon("ic_end_date"),
                            textFont: .body,
                            iconSize: 16,
                            requiresSpacerAtEnd: true
                        )
                    }
                }
            }.padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                .contentShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 2)
        }
    }
}
