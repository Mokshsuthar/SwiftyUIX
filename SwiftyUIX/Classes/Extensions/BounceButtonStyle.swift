//
//  BounceButtonStyle.swift
//  SwiftyUIX
//
//  Created by Moksh on 06/11/25.
//


import Foundation
import SwiftUI

public struct BounceButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
