
#if os(iOS)
import StoreKit
import UIKit

public extension SKStoreReviewController {
    func requestReviewInCS() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
#endif
