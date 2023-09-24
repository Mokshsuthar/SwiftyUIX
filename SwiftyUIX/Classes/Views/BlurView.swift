//
//  BlurView.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

#if os(iOS)
import SwiftUI

// The struct BlurView is a UIViewRepresentable that creates a visual blur effect view using the given UIBlurEffect.Style.
// This SwiftUI view wraps a UIVisualEffectView, which applies a blur effect based on the specified style.
// The default style is .systemChromeMaterial, representing the standard system blur appearance.
// It can be initialized with a different style to customize the blur effect.

public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    public let style: UIBlurEffect.Style
    
    public init(style: UIBlurEffect.Style = .systemChromeMaterial) {
        self.style = style
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}

#endif
