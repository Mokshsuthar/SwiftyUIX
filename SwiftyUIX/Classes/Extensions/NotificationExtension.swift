//
//  NotificationExtension.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 24/09/23.
//

import Foundation
extension NSNotification.Name {

    func fire() {
        NotificationCenter.default.post(name: self, object: nil)
    }
    
    func fire(value : [String : Any]) {
        NotificationCenter.default.post(name: self, object: nil,userInfo: value)
    }
    
}
