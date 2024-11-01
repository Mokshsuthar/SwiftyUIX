//
//  BlurBackgroundView.swift
//
//  Created by Moksh on 24/07/24.
//

 
#if os(macOS)
import Foundation
import SwiftUI

public struct BlurView: View {
    // MARK: - Properties
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var overlayColor: Color
    
    // MARK: - Initializer
    public init(material: NSVisualEffectView.Material = .hudWindow , blendingMode: NSVisualEffectView.BlendingMode = .behindWindow, overlayColor: Color = Color.white.opacity(0.2)) {
        self.material = material
        self.blendingMode = blendingMode
        self.overlayColor = overlayColor
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            VisualEffectView(material: material, blendingMode: blendingMode)
//                .fullFrame()
                .frame(minWidth: 100, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100, idealHeight: 100, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            overlayColor
                .frame(minWidth: 100, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100, idealHeight: 100, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                .fullFrame()
        }
    }
}

public struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    public func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

#endif
