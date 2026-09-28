//
//  UIApplicationExtension.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 24/09/23.
//

import Foundation

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
public typealias PlatformWindow = UIWindow
public typealias PlatformViewController = UIViewController
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
public typealias PlatformWindow = NSWindow
public typealias PlatformViewController = NSViewController
#endif

// MARK: - Bundle metadata (all platforms)

public extension Bundle {

    /// Uses `object(forInfoDictionaryKey:)` so localized values from InfoPlist.strings are respected.
    private func infoString(_ key: String) -> String? {
        object(forInfoDictionaryKey: key) as? String
    }

    var displayName: String? {
        infoString("CFBundleDisplayName") ?? infoString(kCFBundleNameKey as String)
    }

    var appVersion: String? {
        infoString("CFBundleShortVersionString")
    }

    var buildNumber: String? {
        infoString(kCFBundleVersionKey as String)
    }

    /// e.g. "1.4.2 (87)"
    var fullVersion: String {
        "\(appVersion ?? "–") (\(buildNumber ?? "–"))"
    }

    var appIcon: PlatformImage? {
        #if canImport(UIKit)
        let icons = (infoDictionary?["CFBundleIcons"] ?? infoDictionary?["CFBundleIcons~ipad"]) as? [String: Any]
        let primary = icons?["CFBundlePrimaryIcon"] as? [String: Any]

        if let file = (primary?["CFBundleIconFiles"] as? [String])?.last,
           let image = UIImage(named: file, in: self, compatibleWith: nil) {
            return image
        }
        if let name = primary?["CFBundleIconName"] as? String {
            return UIImage(named: name, in: self, compatibleWith: nil)
        }
        return nil
        #elseif canImport(AppKit)
        return NSWorkspace.shared.icon(forFile: bundlePath)
        #endif
    }
}

// MARK: - Shorthand on UIApplication / NSApplication (keeps existing call sites working)

public protocol AppInfoProviding {}

public extension AppInfoProviding {
    var displayName: String? { Bundle.main.displayName }
    var appVersion: String? { Bundle.main.appVersion }
    var buildNumber: String? { Bundle.main.buildNumber }
    var fullVersion: String { Bundle.main.fullVersion }
    var appIcon: PlatformImage? { Bundle.main.appIcon }
}

// MARK: - iOS / iPadOS / tvOS / Mac Catalyst

#if canImport(UIKit)
extension UIApplication: AppInfoProviding {}

public extension UIApplication {

    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /// Key window of the active scene. Falls back to an inactive foreground scene
    /// (e.g. during launch or when Control Center is open).
    func findKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, tvOS 13.0, *) {
            let scenes = connectedScenes.compactMap { $0 as? UIWindowScene }
            let ordered = scenes.filter { $0.activationState == .foregroundActive }
                        + scenes.filter { $0.activationState == .foregroundInactive }

            for scene in ordered {
                if #available(iOS 15.0, tvOS 15.0, *), let key = scene.keyWindow {
                    return key
                }
                if let key = scene.windows.first(where: \.isKeyWindow) {
                    return key
                }
            }
            return nil
        } else {
            return keyWindow
        }
    }

    /// Top-most visible view controller. Pass `base` to start from a specific controller,
    /// otherwise starts from the key window's root.
    ///
    /// Handles modals (skipping ones being dismissed), navigation, tab bar (incl. "More"),
    /// and split view controllers.
    func topViewController(base: UIViewController? = nil) -> UIViewController? {
        guard var current = base ?? findKeyWindow()?.rootViewController else { return nil }

        while true {
            if let presented = current.presentedViewController, !presented.isBeingDismissed {
                current = presented
            } else if let nav = current as? UINavigationController, let visible = nav.visibleViewController {
                current = visible
            } else if let tab = current as? UITabBarController, let selected = tab.selectedViewController {
                current = selected
            } else if let split = current as? UISplitViewController, let last = split.viewControllers.last {
                current = last
            } else {
                return current
            }
        }
    }
}

#endif
