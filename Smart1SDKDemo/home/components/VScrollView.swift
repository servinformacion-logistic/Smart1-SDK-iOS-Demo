//
//  VScrollView.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import SwiftUI

/// It centers the content of a view into an ScrollView component
struct VScrollView<Content>: View where Content: View {
  @ViewBuilder let content: Content
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical) {
        content
          .frame(width: geometry.size.width)
          .frame(minHeight: geometry.size.height)
      }
    }
  }
}
