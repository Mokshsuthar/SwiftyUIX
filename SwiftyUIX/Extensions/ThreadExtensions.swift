//
//  ThreadExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

import Foundation

public extension Thread{
    /*
     Executes the given completion closure on the main thread if the current thread is already the main thread. Otherwise, dispatches it asynchronously to the main thread for execution.
     */
    static func OnMainThread(_ completion:@escaping () -> ()){
        if Thread.current.isMainThread{
            completion()
        }else{
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /* Executes the given completion closure on a background thread using a global background queue. */
    static func OnBackGroudThread(_ completion:@escaping () -> ()){
        DispatchQueue.global(qos: .background).async {
            completion()
        }
    }
    
    
    /* Schedules the given completion closure to run after a specified delay (in seconds) on the main thread using DispatchQueue.main.asyncAfter.*/
    static func runAfter(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            completion()
        })
    }
    
    /*Extensions to create and manage custom threads with specific configurations.*/
    static func startNewThread(name: String, qos: QualityOfService = .default, execute closure: @escaping () -> Void) {
           let thread = Thread {
               closure()
           }
           thread.name = name
           thread.qualityOfService = qos
           thread.start()
       }

}
