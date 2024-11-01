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
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // Get the width of the device screen
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    } 

    // Get the height of the device's notch (if applicable)
    var topSafeAreaHeight: CGFloat {
        return UIDevice.current.topSafeArea
    }
    
    // Get the height of the device's notch (if applicable)
    var bottomSafeAreaHeight: CGFloat {
        return UIDevice.current.bottomSafeArea
    }

    // Check if the device height is less than the small screen height threshold
    var isSmallScreen: Bool {
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
     * Use `fullFrame()` or `fullFrame(alignment:)` with optional alignment to align the view.
     * The frame is set with minimum width/height as 0, ideal width/height as 100, and max width/height as infinity
     * to ensure the view occupies the entire available space both horizontally and vertically within its parent.
     */
    func fullFrame(alignment : Alignment = .center) -> some View {
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
    
    
    func cornerRadius(_ continuesRadius : CGFloat) -> some View {
        return self.mask(RoundedRectangle(cornerRadius: continuesRadius,style: .continuous).fill(Color.white))
    }
    

    
    //scroll position Detection
    func getScrollPosition(key : String,handler : @escaping (CGFloat) -> Void) -> some View {
        return self.background( GeometryReader { Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named(key)).origin.y) }).onPreferenceChange(ViewOffsetKey.self) { handler($0) }
    }
   
    //direct systmeicon image view
    func systemImage(_ name : String) -> some View{
        return Image(systemName: name).resizeWithAspectRatio()
    }
    
    func border(lineWidth : CGFloat,cornerRadius : CGFloat,color : Color) -> some View{
        return self.overlay(BorderView(radius: cornerRadius, lineWidth: lineWidth, color: color))
    }
    
    @inlinable func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
            self.mask(
                ZStack {
                    Rectangle()

                    mask()
                        .blendMode(.destinationOut)
                }
            )
        }
    
    
    #if os(macOS)
    func roundedCorners(radius: CGFloat, corners: RectCorner) -> some View {
        clipShape( RoundedCornersShape(radius: radius, corners: corners) )
    }
    #endif
    
    
    
   #if os(iOS)
    
    //show apple like feedback drop
    // example when you toggle between mute and ring mode by side switch and you get small drop at the top
    func showDrop(title : String,subtitle : String?,icon : UIImage?,action : Drop.Action?,position : Drop.Position = .top,duration : Drop.Duration = .seconds(2),accessibility : Drop.Accessibility?,haptic : feedbackType? = nil)
    {
        let drop = Drop(title: title, titleNumberOfLines: 1, subtitle: subtitle, subtitleNumberOfLines: 1, icon: icon, action: action, position: position, duration: duration, accessibility: accessibility)
        
        Drops.shared.hideAll()
        Drops.shared.show(drop)
        
        if let haptic{
            HapticFeedbackManager.shared.hapticFeedback(type: haptic)
        }
    }
    
    
    //show System Alert
    func showAlert(title : String,message : String,actions : [UIAlertAction],preferredStyle : UIAlertController.Style = .alert) {
        
        if let topView = UIApplication.topViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                alert.addAction(action)
            }
           
            topView.present(alert, animated: true)
        }
    }
    
    //Open ShareSheet
    func ShareSheet(activityItems: [Any]) {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        guard var topVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        // iterate til we find the topmost presented view controller
        // if you don't you'll get an error since you can't present 2 vcs from the same level
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = UIView()
        }
        
        topVC.present(activityController, animated: true)
    }
    
    //play HapticFeedback
    func playHapticFeedback(type : feedbackType) {
        HapticFeedbackManager.shared.hapticFeedback(type: type)
    }
    #endif
    
    var appEnvirement : AppConfiguration {
        return Config.appConfiguration
    }

   
    
    
}

public extension Image {
    //rectsize with aspect retio
    func squareFrameWithApectRatio(value : CGFloat,contentMode : ContentMode = .fit) -> some View {
        return self.resizable().aspectRatio( contentMode: contentMode).squareFrame(size: value)
    }
    //imageResize and aspect ratio
    func resizeWithAspectRatio(contentMode : ContentMode = .fit) -> some View {
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
#if os(macOS)
// defines OptionSet, which corners to be rounded – same as UIRectCorner
public struct RectCorner: OptionSet, Sendable {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
        
    static public let topLeft = RectCorner(rawValue: 1 << 0)
    static public let topRight = RectCorner(rawValue: 1 << 1)
    static public let bottomRight = RectCorner(rawValue: 1 << 2)
    static public let bottomLeft = RectCorner(rawValue: 1 << 3)
    
    static public let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]
}

// draws shape with specified rounded corners applying corner radius
public struct RoundedCornersShape: Shape {
    
    var radius: CGFloat = .zero
    var corners: RectCorner = .allCorners

   public func path(in rect: CGRect) -> Path {
        var path = Path()

        let p1 = CGPoint(x: rect.minX, y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY )
        let p2 = CGPoint(x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX, y: rect.minY )

        let p3 = CGPoint(x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX, y: rect.minY )
        let p4 = CGPoint(x: rect.maxX, y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY )

        let p5 = CGPoint(x: rect.maxX, y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY )
        let p6 = CGPoint(x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX, y: rect.maxY )

        let p7 = CGPoint(x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX, y: rect.maxY )
        let p8 = CGPoint(x: rect.minX, y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY )

        
        path.move(to: p1)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                    tangent2End: p2,
                    radius: radius)
        path.addLine(to: p3)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                    tangent2End: p4,
                    radius: radius)
        path.addLine(to: p5)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                    tangent2End: p6,
                    radius: radius)
        path.addLine(to: p7)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                    tangent2End: p8,
                    radius: radius)
        path.closeSubpath()

        return path
    }
}
#endif
