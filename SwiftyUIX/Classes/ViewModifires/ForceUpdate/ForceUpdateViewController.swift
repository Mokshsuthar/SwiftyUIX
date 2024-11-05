//
//  ForceUpdateViewController.swift
//  SwiftyUIX
//
//  Created by Moksh on 05/11/24.
//

#if os(iOS)
 
import UIKit
import SwiftUI

class ForceUpdateViewController: UIViewController,ObservableObject {

    var appID : String?
    var showCloseButton : Bool = forceUpdateModel.shared.showCloseButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSwiftUIChildView(ForceUpdateView(model: self))
    }
    

    func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateAction() {
        if let appID {
            if let appStoreLink = URL(string: "https://apps.apple.com/app/id\(appID)") {
                UIApplication.shared.open(appStoreLink)
            } else {
                fatalError("Invalid url")
            }
           
            
        } else {
            fatalError("App ID not found")
        }
        
    }
    
}
#endif
