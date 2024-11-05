//
//  ColorsExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 21/07/23.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public extension Color {
    
    init(hexString: String) {
           let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int = UInt64()
           Scanner(string: hex).scanHexInt64(&int)
           let r, g, b: UInt64
           switch hex.count {
           case 3: // RGB (12-bit)
               (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
           case 6: // RGB (24-bit)
               (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
           case 8: // ARGB (32-bit)
               (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
           default:
               (r, g, b) = (0, 0, 0)
           }
           self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
       }
 
    
   
#if os(iOS)
    @available(iOS 14.0, *)
    func toHex() -> String? {
            let uic = UIColor(self)
            guard let components = uic.cgColor.components, components.count >= 3 else {
                return nil
            }
            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)

            if components.count >= 4 {
                a = Float(components[3])
            }

            if a != Float(1.0) {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
    }
    #elseif os(macOS)
    func toHex() -> String? {
            let uic = NSColor(self)
            guard let components = uic.cgColor.components, components.count >= 3 else {
                return nil
            }
            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)

            if components.count >= 4 {
                a = Float(components[3])
            }

            if a != Float(1.0) {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
    }
    #endif
   
}

#if os(iOS)
extension UIColor {
    func toHexCode() -> String? {
        guard let components = self.cgColor.components else {
            return nil
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let hexCode = String(format: "#%02lX%02lX%02lX",
                             lroundf(red * 255),
                             lroundf(green * 255),
                             lroundf(blue * 255))
        
        return hexCode
    }
}
#endif

#if os(macOS)
extension NSColor {
    func toHexCode() -> String? {
        guard let components = self.cgColor.components else {
            return nil
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let hexCode = String(format: "#%02lX%02lX%02lX",
                             lroundf(red * 255),
                             lroundf(green * 255),
                             lroundf(blue * 255))
        
        return hexCode
    }
}

#endif
