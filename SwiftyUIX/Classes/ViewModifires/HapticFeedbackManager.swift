//
//  HapticFeedbackManager.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

#if os(iOS)
import Foundation
import UIKit
import SwiftUI
class HapticFeedbackManager {
    static var shared = HapticFeedbackManager()
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    func hapticFeedback(type :feedbackType){
       switch type {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}

public extension ObservedObject {
    func playHapticFeedback(_ type : feedbackType) {
        HapticFeedbackManager.shared.hapticFeedback(type: type)
    }
}

public enum feedbackType {
    case error,success,warning,light,medium,heavy
}



#endif
