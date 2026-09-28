//
//  GlassExtensions.swift
//  SwiftyUIX
//
//  Created by John kim on 9/23/26.
//

import Foundation
import SwiftUI

public struct SafeGlassContainer<Content: View>: View {
    var spacing: CGFloat?
    @ViewBuilder var content: () -> Content

    public init(spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                content()
            }
        } else {
            content()
        }
    }
}


//#Preview {
//    SafeGlassContainer(spacing: 16) {
//        HStack{
//            Text("Hello, Glass!")
//                .padding(12)
//                .padding(6)
//                .safeGlassEffect(.clear, fallback: Color.white, isInteractive: true, clipShape: .capsule, tintColor: Color.green.opacity(0.7), glassEffectID: nil)
//            
//            Text("Hello, Glass!")
//                .padding(12)
//                .padding(6)
//                .safeGlassEffect(.clear, fallback: Color.white, isInteractive: true, clipShape: .capsule, tintColor: Color.red.opacity(0.7), glassEffectID: nil)
//        }
//       
//    }
//}

public extension View {

    // MARK: - New API (iOS + macOS)

    @available(iOS 15.0, macOS 12.0, *)
    @ViewBuilder
    func safeGlassEffect<S: ShapeStyle>(
        _ type: GlassEffectProperties,
        fallback fallbackStyle: S,
        isInteractive: Bool = false,
        clipShape: some Shape = .capsule,
        tintColor: Color? = nil,
        glassEffectID: String? = nil,
        nameSpace: Namespace.ID? = nil
    ) -> some View {
        if #available(anyAppleOS 26.0, *) {
            let glass: Glass = (type == .clear) ? .clear : .regular
            let view = self.glassEffect(glass.tint(tintColor).interactive(isInteractive), in: clipShape)
            if let nameSpace {
                view.glassEffectID(glassEffectID, in: nameSpace)
            }
            
        } else {
            self.background(fallbackStyle).clipShape(clipShape)
        }
    }

    // MARK: - Deprecated (iOS)

    #if os(iOS)
    @available(iOS 15.0, *)
    @available(*, deprecated, renamed: "safeGlassEffect(_:fallback:isInteractive:clipShape:tintColor:glassEffectID:)")
    func safe_glassEffect(
        _ type: GlassEffectProperties,
        _ fallBackMaterial: Material,
        isintractive: Bool = false,
        clipShape: some Shape = .capsule,
        tintColor: Color? = nil,
        glassEffectID: String? = nil
    ) -> some View {
        safeGlassEffect(type, fallback: fallBackMaterial, isInteractive: isintractive,
                        clipShape: clipShape, tintColor: tintColor, glassEffectID: glassEffectID)
    }

    @available(iOS 15.0, *)
    @available(*, deprecated, renamed: "safeGlassEffect(_:fallback:isInteractive:clipShape:tintColor:glassEffectID:)")
    func safe_glassEffectWithFallBackColor(
        _ type: GlassEffectProperties,
        _ fallBackColor: Color,
        isintractive: Bool = false,
        clipShape: some Shape = .capsule,
        tintColor: Color? = nil,
        glassEffectID: String? = nil
    ) -> some View {
        safeGlassEffect(type, fallback: fallBackColor, isInteractive: isintractive,
                        clipShape: clipShape, tintColor: tintColor, glassEffectID: glassEffectID)
    }
    #endif

    // MARK: - Deprecated (macOS)

    #if os(macOS)
    @available(macOS 12.0, *)
    @available(*, deprecated, renamed: "safeGlassEffect(_:fallback:isInteractive:clipShape:tintColor:)")
    func safe_glassEffect(
        _ type: GlassEffectProperties,
        _ fallBackMaterial: Material,
        isInteractive: Bool = false,
        clipShape: some Shape = .capsule,
        tintColor: Color? = nil
    ) -> some View {
        safeGlassEffect(type, fallback: fallBackMaterial, isInteractive: isInteractive,
                        clipShape: clipShape, tintColor: tintColor)
    }

    @available(macOS 12.0, *)
    @available(*, deprecated, renamed: "safeGlassEffect(_:fallback:isInteractive:clipShape:tintColor:)")
    func safe_glassEffectWithFallBackColor(
        _ type: GlassEffectProperties,
        _ fallBackColor: Color,
        isInteractive: Bool = false,
        clipShape: some Shape = .capsule,
        tintColor: Color? = nil
    ) -> some View {
        safeGlassEffect(type, fallback: fallBackColor, isInteractive: isInteractive,
                        clipShape: clipShape, tintColor: tintColor)
    }
    #endif
}
