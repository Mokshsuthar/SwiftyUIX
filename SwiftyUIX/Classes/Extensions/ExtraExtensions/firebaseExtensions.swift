//
//  firebaseExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 23/09/23.
//

#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
// Code that depends on Foundation framework
extension View {
    func setEvent(_ value : String) {
        Analytics.logEvent(value, parameters: nil)
    }
}

extension ObservableObject {
    func setEvent(_ value : String) {
        Analytics.logEvent(value, parameters: nil)
    }
}

extension UIViewController {
    func setEvent(_ value : String) {
        Analytics.logEvent(value, parameters: nil)
    }
}

extension String {
    func asFirebaseEvent() {
        Analytics.logEvent(self, parameters: nil)
    }
}

#endif
