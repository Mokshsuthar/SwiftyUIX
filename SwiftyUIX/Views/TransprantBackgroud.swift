//
//  TransprantBackgroud.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
// SwiftUI UIViewRepresentable to make the background transparent for a presented sheet or fullscreen cover.
// The purpose of this struct, TransprentBackground, is to remove the default background and allow the content below it to show through. However, setting the background color of the superview's superview directly might have unintended side effects and may not be reliable across all SwiftUI versions or implementations. It's important to thoroughly test this code and consider potential edge cases before using it in production.

struct TransprentBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


#endif

