//
//  UIdeviceExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 21/07/23.
//

import Foundation


#if os(iOS)
import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    public var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    /// Returns the height of the notch area, or 0 if not applicable
    public var topSafeArea: CGFloat {
        guard #available(iOS 11.0, *), let window =  UIApplication.shared.windows.filter({$0.isKeyWindow}).first   else { return 0 }
        return window.safeAreaInsets.top
    }
    
    /// Returns the height of the bottom safe area, or 0 if not applicable
    public var bottomSafeArea: CGFloat {
        guard #available(iOS 11.0, *), let window =  UIApplication.shared.windows.filter({$0.isKeyWindow}).first  else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
    /// Returns `true` if the device is an iPad
    public var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
#endif

