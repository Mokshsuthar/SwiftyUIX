
#if canImport(UIKit)
import StoreKit
import UIKit

@available(iOS 14.0, *)
public extension SKStoreReviewController {
    func requestReviewInCS() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
#endif
