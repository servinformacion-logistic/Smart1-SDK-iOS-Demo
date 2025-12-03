//
//  CounterText.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI

struct CounterText: View {
    var text: String
    var size : CGFloat = 30
    var backgroundColor : Color = .primary
    var textColor : Color = .accentColor
    var textFont : Font = .body
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            Text(text)
                .padding(4)
                .foregroundColor(textColor)
                .font(textFont)
                .multilineTextAlignment(.center)
        }
    }
}

struct Smart1CounterText_Previews: PreviewProvider {
    static var previews: some View {
        CounterText(text: "60")
    }
}
