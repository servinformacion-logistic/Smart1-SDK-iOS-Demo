//
//  Icons.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 24/11/25.
//

import SwiftUI

struct Icons {
    
    func systemIcon(
        _ name: String
    ) -> Image {
        return Image(systemName: name)
    }
    
    func resourceIcon(
        _ name: String
    ) -> Image {
        return Image(
            uiImage: UIImage(
                named: name
            )!
        ).renderingMode(.template)
    }
    
    func resourceImage(
        _ name: String
    ) -> Image {
        return Image(
            uiImage: UIImage(
                named: name
            )!
        )
    }
    
    func checkBox(
        _ isChecked: Bool
    ) -> Image {
        return Image(systemName: isChecked ? "checkmark.square.fill" : "square")
    }
}
