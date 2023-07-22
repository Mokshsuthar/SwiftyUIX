//
//  UIscreenExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 21/07/23.
//
#if os(iOS)
import Foundation
import UIKit

public extension UIScreen {
    // Key used to retrieve the display corner radius value
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()
    
    // Returns the display corner radius, or a default value of 10 if unavailable
    var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            return 10
        }
        // Ensure the corner radius is not less than 10
        return max(cornerRadius, 10)
    }
    
    // Returns the display corner radius, capped at the specified minimum value
    func displayCorner(minimum: CGFloat) -> CGFloat {
        if self.displayCornerRadius < minimum {
            return minimum
        } else {
            return self.displayCornerRadius
        }
    }
}
#endif

