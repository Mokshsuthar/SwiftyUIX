//
//  UIViewControllerExtension.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 24/09/23.
//

#if canImport(UIKit)
import Foundation
import UIKit
import SwiftUI

public extension UIViewController {
    //show UIAlert View
    func showAlert(title : String,message : String,actions : [UIAlertAction],preferredStyle : UIAlertController.Style = .alert) {
        
        if let topView = UIApplication.topViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                alert.addAction(action)
            }
           
            topView.present(alert, animated: true)
        }
    }
    
    //show apple like feedback drop
    // example when you toggle between mute and ring mode by side switch and you get small drop at the top
    func showDrop(title : String,subtitle : String?,icon : UIImage?,action : Drop.Action?,position : Drop.Position = .top,duration : Drop.Duration = .seconds(2),accessibility : Drop.Accessibility?,haptic : feedbackType? = nil)
    {
        let drop = Drop(title: title, titleNumberOfLines: 1, subtitle: subtitle, subtitleNumberOfLines: 1, icon: icon, action: action, position: position, duration: duration, accessibility: accessibility)
        
        Drops.shared.hideAll()
        Drops.shared.show(drop)
        
        if let haptic{
            HapticFeedbackManager.shared.hapticFeedback(type: haptic)
        }
    }
    
    
    //Open ShareSheet
    func ShareSheet(activityItems: [Any]) {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        guard var topVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        // iterate til we find the topmost presented view controller
        // if you don't you'll get an error since you can't present 2 vcs from the same level
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = UIView()
        }
        
        topVC.present(activityController, animated: true)
    }
    
    //play HapticFeedback
    func playHapticFeedback(type : feedbackType) {
        HapticFeedbackManager.shared.hapticFeedback(type: type)
    }
    
    
    func addSwiftUIChildView<V: View>(_ view: V) {
        let childView = UIHostingController(rootView: view)
        childView.view.backgroundColor = .clear
        addChild(childView)
        
        // Set the frame to match the view controller's view bounds
        childView.view.frame = self.view.bounds
        self.view.addSubview(childView.view)
        
        childView.didMove(toParent: self)
    }
    

    func addSwiftUIChildView<V: View>(_ swiftUIView: V, to containerView: UIView) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .clear
        
        // Add the hosting controller as a child to the view's view controller
        if let viewController = containerView.findViewController() {
            viewController.addChild(hostingController)
        }
        
        // Add the SwiftUI view as a subview of the container UIView
        hostingController.view.frame = containerView.bounds
        containerView.addSubview(hostingController.view)
        
        // Notify the hosting controller that it was moved to the new parent
        hostingController.didMove(toParent: containerView.findViewController())
    }


    
}

extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


#endif

