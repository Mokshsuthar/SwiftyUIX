//
//  ButtonExtension.swift
//  SwiftyUIX
//
//  Created by Moksh on 30/10/24.
//

import SwiftUI 
public extension Button {
    /// Applies a borderless button style.
    func borderless() -> some View {
        self.buttonStyle(BorderlessButtonStyle())
    }
}
