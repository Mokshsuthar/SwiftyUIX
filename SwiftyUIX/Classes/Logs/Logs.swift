//
//  Logs.swift
//  SwiftyUIX
//
//  Created by Moksh on 01/11/24.
//

import os.log

public class Log {
    static public func debug(_ message  : String){
        if Config.appConfiguration != .Debug { return }
        if #available(iOS 14.0, *) {
            os_log(.debug, "\(message)")
        } else {
            print("🟡 Log: \(message)")
        }
    }
    
    static public func defaultLog(_ message  : String){
        if Config.appConfiguration != .Debug { return }
        if #available(iOS 14.0, *) {
            os_log(.default, "\(message)")
        } else {
            print("◻️ Log: \(message)")
        }
    }
    
    static public func error(_ message  : String){
        if Config.appConfiguration != .Debug { return }
        if #available(iOS 14.0, *) {
            os_log(.error, "\(message)")
        } else {
            print("🔴 Log: \(message)")
        }
       
    }
    
    static public func info(_ message  : String){
        if Config.appConfiguration != .Debug { return }
        if #available(iOS 14.0, *) {
            os_log(.info, "\(message)")
        } else {
            print("🟢 Log: \(message)")
        }
       
    }
    static public func fault(_ message  : String){
        if Config.appConfiguration != .Debug { return }
        if #available(iOS 14.0, *) {
            os_log(.fault, "\(message)")
        } else {
            print("🚨 Log: \(message)")
        }
        
    }
}
