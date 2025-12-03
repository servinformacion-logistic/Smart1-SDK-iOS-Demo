//
//  LoadingDialog.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI

struct LoadingDialog: View {
    var isOpen    : Bool
    var onDismiss : () -> Void
    var text      : String? = nil
    @State private var keyboardHeight: CGFloat = 0
    var body: some View {
        CustomDialog(
            isOpen    : isOpen,
            onDismiss : {
                keyboardHeight = 0
                onDismiss()
            },
            isDynamicWidth: true,
            isDynamicHeight: true,
            keyboardHeight: _keyboardHeight
        ) {
            VStack(
                alignment: HorizontalAlignment.center
            ) {
                if let nonNullText = text {
                    Text(nonNullText)
                        .foregroundColor(.black)
                        .font(.title3)
                }
                ProgressView()
                    .animation(.easeInOut, value: true)
                    .progressViewStyle(
                        CircularProgressViewStyle(
                            tint: .primary
                        )
                    )
                    .frame(width: 10, height: 10)
                    .padding(.bottom, 4)
            }.padding(16)
        }
    }
}

#Preview {
    LoadingDialog(
        isOpen: true,
        onDismiss: {},
        text: "Test Loading..."
    )
}
