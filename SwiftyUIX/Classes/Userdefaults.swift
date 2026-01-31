//
//  Userdefaults.swift
//  SwiftyUIX
//
//  Created by Moksh on 07/11/25.
//


import Foundation

typealias Defaults = UserDefaults

public extension UserDefaults {
    //MARK: SwiftyUIX Tags
    //Please do not place any of you app tags here because they will be removed when you update your pods.
    static var isHapticEnabled: Bool {
        get { getOrSetUserDefault(key: #function, defaultValue: true) }
        set { standard.set(newValue, forKey: #function) }
    }
    
    
    static var bottomSafeArea: CGFloat? {
        get { getOrSetUserDefault(key: #function, defaultValue: nil) }
        set { standard.set(newValue, forKey: #function) }
    }
    
    static var topSafeArea: CGFloat? {
        get { getOrSetUserDefault(key: #function, defaultValue: nil) }
        set { standard.set(newValue, forKey: #function) }
    }
    
    //Common Function
    private static func getOrSetUserDefault<T>(key: String, defaultValue: T) -> T {
        if let value = standard.object(forKey: key) as? T {
            return value
        }
        standard.set(defaultValue, forKey: key)
        return defaultValue
    }
    
    
}
