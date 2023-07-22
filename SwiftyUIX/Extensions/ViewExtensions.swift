//
//  ViewExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 20/07/23.
//

import Foundation
import SwiftUI


public extension View {
    
    //MARK: - Frame related Extentions
    
#if os(iOS)
    // Get the height of the device screen
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // Get the width of the device screen
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Get the height of the device's notch (if applicable)
    static var topSafeAreaHeight: CGFloat {
        return UIDevice.current.topSafeArea
    }

    // Check if the device height is less than the small screen height threshold
    static var isSmallScreen: Bool {
        let smallScreenHeightThreshold: CGFloat = 815
        return UIScreen.main.bounds.height < smallScreenHeightThreshold
    }
    
    // Returns the corner radius of the device's display, capped at the specified minimum value
    func screenCornerRadius(minimum: CGFloat = 0) -> CGFloat {
        // Retrieve the display corner radius from the main screen
        return UIScreen.main.displayCorner(minimum: minimum)
    }
    
    // Hides the home indicator on devices running iOS 16.0 or later
    func hideHomeIndicator() -> some View {
        if #available(iOS 16.0, *) {
            // Use the `persistentSystemOverlays` modifier with `.hidden` to hide the home indicator
            return self.persistentSystemOverlays(.hidden)
        } else {
            // Return the original view as is for devices running earlier versions of iOS
            return self
        }
    }
    
    //to play HapticFeedback
    func playHapticFeedback(_ type : feedbackType) {
        HapticFeedbackManager.shared.hapticFeedback(type: type)
    }
    
    // By calling this function on a SwiftUI view, you can easily add rounded corners to that view with specified radius and corners.
    // Example usage: someView.cornerRadius(10, corners: [.topLeft, .topRight])
    // This will apply a corner radius of 10 to the top-left and top-right corners of `someView`.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
#endif
   
    // Ignores the safe area insets of the device on iOS 14 and above
    func ignoreSafeArea_C() -> some View {
        if #available(iOS 14.0, *) {
            return self.ignoresSafeArea()
        } else {
            return self
        }
    }

    /**
     * SwiftUI extension to make a view fill its parent's space.
     * Use `fullframe()` or `fullframe(alignment:)` with optional alignment to align the view.
     * The frame is set with minimum width/height as 0, ideal width/height as 100, and max width/height as infinity
     * to ensure the view occupies the entire available space both horizontally and vertically within its parent.
     */
    func fullframe(alignment : Alignment = .center) -> some View {
        return self.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: alignment)
    }
    
    /**
     SwiftUI extension to set the frame with full available width and optional height.
    */
    
    func fullWidth(height : CGFloat? = nil,alignment : Alignment = .center) -> some View {
        if let height {
            return self.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: alignment)
        }
        else {
            return self.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, alignment: alignment)
        }
    }
    
    /**
     SwiftUI extension to set the frame with full available height and optional width.
    */
    
    func fullHeight(width : CGFloat? = nil,alignment : Alignment = .center) -> some View {
        if let width {
            return self.frame(minWidth: width, idealWidth: width, maxWidth: width, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: alignment)
        }
        else {
            return self.frame(minHeight: 0,idealHeight: 100,maxHeight: .infinity, alignment: alignment)
        }
    }
    
    
    func squareFrame(size : CGFloat,alignment : Alignment = .center) -> some View {
        return self.frame(width : size,height: size,alignment: alignment)
    }
    
    
    func cornerRadius(_ countinuesradius : CGFloat) -> some View {
        return self.mask(RoundedRectangle(cornerRadius: countinuesradius,style: .continuous).fill(Color.white))
    }
    
#if os(iOS)
    // Adjusts the view's frame to account for the bottom safe area
    func bottomSafeArea(width: CGFloat = 0, plus: CGFloat = 0, ifZero: CGFloat = 0) -> some View {
        if UIDevice.current.bottomSafeArea == 0 {
            // If the bottom safe area size is 0, return the view with the adjusted height
            return self.frame(width: width, height: ifZero + plus, alignment: .center)
        } else {
            // If the bottom safe area size is not 0, return the view with the adjusted height
            return self.frame(width: width, height: UIDevice.current.bottomSafeArea + plus, alignment: .center)
        }
    }
    
    // Adjusts the view's frame to account for the notch size on the device
    func topSafeArea(width: CGFloat = 0, plus: CGFloat = 0) -> some View {
        // Get the notch size from the current device
        let notchSize = UIDevice.current.topSafeArea
        
        // Return the view with the adjusted height to accommodate the notch
        return self.frame(width: width, height: notchSize + plus, alignment: .center)
    }
#endif
    
    //scroll position Detection
    func getScrollPosition(key : String,handler : @escaping (CGFloat) -> Void) -> some View {
        return self.background( GeometryReader { Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named(key)).origin.y) }).onPreferenceChange(ViewOffsetKey.self) { handler($0) }
    }
   
    //direct systmeicon image view
    func systemImage(_ name : String) -> some View{
        return Image(systemName: name).resizeWithApectRatio()
    }
    
    //direct systmeicon image view
    func border(lineWidth : CGFloat,cornerRadius : CGFloat,color : Color) -> some View{
        return self.overlay(BorderView(radius: cornerRadius, lineWidth: lineWidth, color: color))
    }
}

public extension Image {
    //rectsize with aspect retio
    func squareFrameWithApectRatio(value : CGFloat,contentMode : ContentMode = .fit) -> some View {
        return self.resizable().aspectRatio( contentMode: contentMode).squareFrame(size: value)
    }
    //imageResize and aspect ratio
    func resizeWithApectRatio(contentMode : ContentMode = .fit) -> some View {
        return self.resizable().aspectRatio( contentMode: contentMode)
    }
}



struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}


#if os(iOS)
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
