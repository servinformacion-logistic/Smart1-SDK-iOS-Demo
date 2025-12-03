//
//  CustomDialog.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI

struct CustomDialog<Content: View>: View {

    var isOpen          : Bool
    let content         : Content
    var onDismiss       : () -> Void
    var isDynamicWidth  : Bool
    var isDynamicHeight : Bool
    @State var keyboardHeight: CGFloat
    var body: some View {
        
        if (isOpen) {
            ZStack {
                Rectangle()
                    .fill(.gray.opacity(0.7))
                    .ignoresSafeArea()
                    .onTapGesture {
                        keyboardHeight = 0
                        onDismiss()
                    }.frame(
                        height: UIScreen.main.bounds.size.height - keyboardHeight
                    ).keyboardHeight($keyboardHeight)
                    .offset(y: -keyboardHeight / 2)

                content
                    .frame(
                        width  : isDynamicWidth ? nil : (UIScreen.main.bounds.size.width - 100),
                        height : isDynamicHeight ? nil : (UIScreen.main.bounds.size.height - 100 - keyboardHeight)
                    )
                    .background(Color.white)
                    .cornerRadius(16)
                    .keyboardHeight($keyboardHeight)
                    .offset(y: -keyboardHeight / 2)
                    .fixedSize(horizontal: isDynamicWidth, vertical: isDynamicHeight)
            }
            .frame(
                width: UIScreen.main.bounds.size.width,
                height: UIScreen.main.bounds.size.height - keyboardHeight,
                alignment: .center
            ).keyboardHeight($keyboardHeight)
                .offset(y: keyboardHeight / 2)
        }
    }
        
}

extension CustomDialog {
    init(
        isOpen: Bool,
        onDismiss: @escaping () -> Void,
        isDynamicWidth : Bool = true,
        isDynamicHeight : Bool = true,
        keyboardHeight: State<CGFloat> = State(initialValue: 0),
        @ViewBuilder _ content: () -> Content
    ) {
        self.isOpen = isOpen
        self.onDismiss = onDismiss
        self.isDynamicWidth = isDynamicWidth
        self.isDynamicHeight = isDynamicHeight
        self._keyboardHeight = keyboardHeight
        self.content = content()
    }
}
