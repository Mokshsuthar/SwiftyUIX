//
//  ObservableObjectExtension.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 24/09/23.
//
#if canImport(UIKit)
import Foundation
import UIKit

public extension ObservableObject {
    
    //Show UIAlertView from Model
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
    func showDrop(title : String,subtitle : String?,icon : UIImage?,action : Drop.Action?,position : Drop.Position = .top,duration : Drop.Duration = .seconds(2),accessibility : Drop.Accessibility?,haptic : feedbackType? = nil) {
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
}
#endif
