//
//  KeyboardMonitor.swift
//  SwiftyUIX
//
//  Created by Moksh on 31/01/26.
//
#if canImport(UIKit)
import SwiftUI
import Combine

public final class KeyboardMonitor: ObservableObject {
    
    // MARK: - Singleton
    
    public static let shared = KeyboardMonitor()
    
    // MARK: - Public State
    
    @Published public private(set) var height: CGFloat = 0
    
    /// Clean publisher for ViewModels
    public var heightPublisher: AnyPublisher<CGFloat, Never> {
        $height.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        let willChange = NotificationCenter.default.publisher(
            for: UIResponder.keyboardWillChangeFrameNotification
        )
        
        let willHide = NotificationCenter.default.publisher(
            for: UIResponder.keyboardWillHideNotification
        )
        
        willChange
            .merge(with: willHide)
            .receive(on: RunLoop.main)
            .map(Self.keyboardHeight)
            .sink { [weak self] newHeight in
                self?.height = newHeight
            }
            .store(in: &cancellables)
    }
    
    private static func keyboardHeight(from notification: Notification) -> CGFloat {
        guard
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return 0 }
        
        let screenHeight = UIScreen.main.bounds.height
        
        if endFrame.origin.y >= screenHeight {
            return 0
        }
        
        let bottomSafeArea = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
        
        return max(0, endFrame.height - bottomSafeArea)
    }
}
#endif
