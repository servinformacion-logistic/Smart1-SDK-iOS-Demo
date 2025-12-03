//
//  OrderItem.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI
import Smart1SDK_iOS

struct OrderItem: View {
    var data    : OrderContainer
    var onClick : (OrderContainer) -> Void = { _ in }
    var body: some View {
        HStack{
            VStack(
                alignment: .leading
            ) {
                Text(
                    "Order # \(data.order.id)"
                )
                .font(.title3.bold())
                .foregroundColor(.black)
                RightIconText(
                    text: "Contains \(data.schedule.count) schedule",
                    icon: Icons().resourceIcon("ic_calendar"),
                    textColor: .black.opacity(0.7),
                    textFont: .body,
                    iconColor: .black.opacity(0.7),
                    iconSize: 18
                )
            }.padding(.vertical, 12)
                .padding(.horizontal, 16)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 2)
            .onTapGesture {
                onClick(data)
            }
    }
}
