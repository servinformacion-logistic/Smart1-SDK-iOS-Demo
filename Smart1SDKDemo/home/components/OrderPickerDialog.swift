//
//  OrderPickerDialog.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import SwiftUI
import Smart1SDK_iOS

struct OrderPickerDialog: View {
    var data            : [OrderContainer]
    let onOrderSelected : (OrderContainer) -> Void
    var body: some View {
        VScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 4)
                    .padding(.bottom, 12)
                    .padding(.top, 8)
                
                Text(
                    "Select a order to visualize"
                )
                .foregroundColor(.accentColor)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                ForEach(
                    data,
                    id: \.self.order.id
                ) { orderSingleItem in
                    OrderItem(
                        data: orderSingleItem,
                        onClick: { orderSingleItem in
                            onOrderSelected(orderSingleItem)
                        }
                    ).listRowInsets(EdgeInsets())
                        .padding(2)
                        .padding(.vertical, 8)
                }.listStyle(.plain)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
        }
    }
}
