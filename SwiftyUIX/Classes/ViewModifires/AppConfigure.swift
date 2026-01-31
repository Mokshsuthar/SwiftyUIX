//
//  AppConfigure.swift
//  SwiftyUIX
//
//  Created by Moksh on 30/10/24.
//

#if canImport(UIKit)
import UIKit
import Foundation
 
public enum AppConfiguration : String {
    case Debug
    case TestFlight
    case AppStore
}

struct Config {
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    // This can be used to add debug statements.
    static var isDebug: Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}

#endif
