//
//  OrderStatusViewer.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI
import Smart1SDK_iOS

struct OrderStatusViewer: View {
    var orderState : OrderState
    var onClick    : () -> Void
    private var text = ""
    private var color = Color.gray
    init(orderState: OrderState, onClick: @escaping () -> Void) {
        self.orderState = orderState
        self.onClick = onClick
        text =
            switch orderState {
            case OrderState.assigned:
                "Start"
            case OrderState.inProgress:
                "In progress"
            case OrderState.completed:
                "Completed"
            default:
                "Unknown"
            }
        color =
            switch orderState {
            case OrderState.assigned:
                Color.blue
            case OrderState.inProgress:
                Color.purple
            case OrderState.completed:
                Color.green
            default:
                Color.gray
            }
    }
    var body: some View {
        Button(
            action: {
                onClick()
            }
        ) {
            HStack {
                if orderState == .assigned {
                    Icons().resourceIcon("ic_start")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                        .onTapGesture {
                            onClick()
                        }
                    Spacer().frame(width: 4)
                }
                Text(
                    text
                )
                    .font(.body.bold())
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(
                color
            )
            .cornerRadius(8)
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2)
        }
    }
}

#Preview {
    OrderStatusViewer(
        orderState: .assigned,
        onClick: {}
    )
}
