//
//  RightIconText.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI

struct RightIconText: View {
    var text : String
    var icon : Image

    var textColor : Color = .accentColor
    var textFont : Font = .body
    var iconColor : Color = .black
    var iconSize : CGFloat = 24
    var requiresSpacerAtEnd : Bool = false
    var body: some View {
        HStack {
            icon
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(iconColor)
            Spacer().frame(width: 8)
            Text(text)
                .font(textFont)
                .foregroundColor(textColor)
            if requiresSpacerAtEnd {
                Spacer()
            }
        }
    }
}

#Preview {
    RightIconText(
        text: "Test",
        icon: Icons().resourceImage("ic_calendar")
    )
}
