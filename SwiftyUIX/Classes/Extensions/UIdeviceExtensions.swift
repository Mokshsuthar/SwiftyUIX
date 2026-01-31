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
        
        guard
            let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
            let window = scene.windows.first(where: { $0.isKeyWindow })
        else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    /// Returns the height of the notch area, or 0 if not applicable
    public var topSafeArea: CGFloat {
        if let topSafrAreaSize = UserDefaults.topSafeArea {
            return topSafrAreaSize
        }
        
        guard
            let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
            let window = scene.windows.first(where: { $0.isKeyWindow })
        else { return 0 }
        return window.safeAreaInsets.top
    }
    
    /// Returns the height of the bottom safe area, or 0 if not applicable
    public var bottomSafeArea: CGFloat {
        if let bottomSafeAreaSize = UserDefaults.bottomSafeArea {
            return bottomSafeAreaSize
        }
        
        guard
            let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
            let window = scene.windows.first(where: { $0.isKeyWindow })
        else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
    /// Returns `true` if the device is an iPad
    public var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @available(*, deprecated, renamed: "isIPad")
    public var isPad: Bool {
        isIPad
    }
}
#endif

