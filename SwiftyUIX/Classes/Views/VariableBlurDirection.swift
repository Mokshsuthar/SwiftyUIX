#if canImport(UIKit)

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins
import QuartzCore

public enum VariableBlurDirection {
    case blurredTopClearBottom
    case blurredBottomClearTop

    // Horizontal
    case blurredLeftClearRight
    case blurredRightClearLeft
}

public struct VariableBlurView: UIViewRepresentable {

    public var maxBlurRadius: CGFloat = 20
    public var direction: VariableBlurDirection = .blurredTopClearBottom

    /// By default, variable blur starts from 0 blur radius and linearly
    /// increases to `maxBlurRadius`.
    public var startOffset: CGFloat = 0

    public init(
        maxBlurRadius: CGFloat = 20,
        direction: VariableBlurDirection = .blurredTopClearBottom,
        startOffset: CGFloat = 0
    ) {
        self.maxBlurRadius = maxBlurRadius
        self.direction = direction
        self.startOffset = startOffset
    }

    public func makeUIView(context: Context) -> VariableBlurUIView {
        VariableBlurUIView(
            maxBlurRadius: maxBlurRadius,
            direction: direction,
            startOffset: startOffset
        )
    }

    public func updateUIView(
        _ uiView: VariableBlurUIView,
        context: Context
    ) {
    }
}

/// credit https://github.com/jtrivedi/VariableBlurView
public class VariableBlurUIView: UIVisualEffectView {

    public init(
        maxBlurRadius: CGFloat = 20,
        direction: VariableBlurDirection = .blurredTopClearBottom,
        startOffset: CGFloat = 0
    ) {
        super.init(effect: UIBlurEffect(style: .regular))

        // CAFilter is a private QuartzCore class that is dynamically
        // created using the Objective-C runtime.
        guard let CAFilter = NSClassFromString("CAFilter") as? NSObject.Type else {
            print("[VariableBlur] Error: Can't find CAFilter class")
            return
        }

        guard let variableBlur = CAFilter
            .perform(
                NSSelectorFromString("filterWithType:"),
                with: "variableBlur"
            )?
            .takeUnretainedValue() as? NSObject
        else {
            print("[VariableBlur] Error: CAFilter can't create filterWithType: variableBlur")
            return
        }

        let gradientImage = makeGradientImage(
            startOffset: startOffset,
            direction: direction
        )

        variableBlur.setValue(maxBlurRadius, forKey: "inputRadius")
        variableBlur.setValue(gradientImage, forKey: "inputMaskImage")
        variableBlur.setValue(true, forKey: "inputNormalizeEdges")

        // UIVisualEffectView gives us access to CABackdropLayer,
        // which can apply real-time CA filters to views underneath.
        let backdropLayer = subviews.first?.layer

        // Replace the standard filters with only variableBlur.
        backdropLayer?.filters = [variableBlur]

        // Remove dimming/tint views.
        for subview in subviews.dropFirst() {
            subview.alpha = 0
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func didMoveToWindow() {
        // Fix visible pixelization at unblurred edge.
        guard let window,
              let backdropLayer = subviews.first?.layer
        else {
            return
        }

        backdropLayer.setValue(
            window.screen.scale,
            forKey: "scale"
        )
    }

    open override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        // super.traitCollectionDidChange(previousTraitCollection)
        // crashes the app.
    }

    private func makeGradientImage(
        width: CGFloat = 100,
        height: CGFloat = 100,
        startOffset: CGFloat,
        direction: VariableBlurDirection
    ) -> CGImage {

        let ciGradientFilter = CIFilter.linearGradient()

        ciGradientFilter.color0 = CIColor.black
        ciGradientFilter.color1 = CIColor.clear

        switch direction {

        // MARK: - Vertical

        case .blurredTopClearBottom:

            ciGradientFilter.point0 = CGPoint(
                x: 0,
                y: height
            )

            ciGradientFilter.point1 = CGPoint(
                x: 0,
                y: startOffset * height
            )

        case .blurredBottomClearTop:

            ciGradientFilter.point0 = CGPoint(
                x: 0,
                y: 0
            )

            ciGradientFilter.point1 = CGPoint(
                x: 0,
                y: height - (startOffset * height)
            )

        // MARK: - Horizontal

        case .blurredLeftClearRight:

            ciGradientFilter.point0 = CGPoint(
                x: 0,
                y: 0
            )

            ciGradientFilter.point1 = CGPoint(
                x: width - (startOffset * width),
                y: 0
            )

        case .blurredRightClearLeft:

            ciGradientFilter.point0 = CGPoint(
                x: width,
                y: 0
            )

            ciGradientFilter.point1 = CGPoint(
                x: startOffset * width,
                y: 0
            )
        }

        return CIContext()
            .createCGImage(
                ciGradientFilter.outputImage!,
                from: CGRect(
                    x: 0,
                    y: 0,
                    width: width,
                    height: height
                )
            )!
    }
}

#endif
