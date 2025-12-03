//
//  SelectableItem.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI

struct SelectableItem: View {
    var text            : String
    var onClick         : () -> Void
    var textColor       : Color = .black
    var textStyle       : Font = .body
    var backgroundColor : Color = Color.accentColor
    
    var body: some View {
        Button(
            action: onClick
        ) {
            HStack {
                Spacer().frame(width: 4)
                Text(text)
                    .foregroundColor(textColor)
                    .font(textStyle)
                    .multilineTextAlignment(.center)
                Spacer().frame(width: 4)
                Icons()
                    .systemIcon("arrowtriangle.down.fill")
                    .resizable()
                    .foregroundColor(textColor)
                    .frame(width: 12, height: 8)
                    .padding(.leading, 6)
                    .padding(.trailing, 4)
            }.padding(12)
        }
            .background(backgroundColor)
            .cornerRadius(16)
    }
}


#Preview {
    SelectableItem(
        text: "Select something",
        onClick: {}
    )
}
