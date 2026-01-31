//
//  UIApplicationExtension.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 24/09/23.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

//get top ViewController 
public extension UIApplication {

    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /**
         Finds the key window for the application, with backward compatibility
         for iOS 14, 13, and pre-iOS 13.
         */
        static func findKeyWindow() -> UIWindow? {
            if #available(iOS 15.0, *) {
                // Modern, simplest way (iOS 15+)
                return UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .compactMap { $0 as? UIWindowScene }
                    .first?
                    .keyWindow
            } else if #available(iOS 13.0, *) {
                // Legacy scene-based way (iOS 13-14)
                // We find the active scene and then its key window.
                return UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .compactMap { $0 as? UIWindowScene }
                    .first?
                    .windows
                    .first(where: { $0.isKeyWindow })
            } else {
                // Pre-scene way (before iOS 13)
                // This is deprecated but necessary for backward compatibility.
                return UIApplication.shared.keyWindow
            }
        }

        /**
         Recursively finds the top-most view controller in the application's view hierarchy.
         
         This function is now backward-compatible and works on all iOS versions.
         It correctly handles:
         - Modally presented view controllers (Checked first)
         - UINavigationControllers
         - UITabBarControllers (including the 'More' tab)
         */
        static func topViewController(base: UIViewController? = UIApplication.findKeyWindow()?.rootViewController) -> UIViewController? {
            
            guard let base = base else {
                return nil
            }
            
            // 1. Check for a modally presented view controller
            // This is the highest layer, so we check it first.
            if let presented = base.presentedViewController {
                return topViewController(base: presented)
            }
            
            // 2. Check for a Navigation Controller
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            
            // 3. Check for a Tab Bar Controller
            if let tab = base as? UITabBarController {
                // Check if the 'More' controller is currently active
                if let top = tab.moreNavigationController.topViewController, top.view.window != nil {
                    return topViewController(base: top)
                }
                // Otherwise, check the regularly selected tab
                else if let selected = tab.selectedViewController {
                    return topViewController(base: selected)
                }
            }
            
            // 4. Base case
            // If it's not a container and nothing is presented, this is the top-most VC.
            return base
        }
    
    
    
    var appIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        
        return UIImage(named: lastIcon)
    }
    
    var displayName: String? {
            return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
                ?? Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
}
#endif



