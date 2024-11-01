//
//  swiftyUIXExamplesApp.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 20/07/23.
//

import SwiftUI

@main
    struct WeatherProAppWrapper {
        static func main() {
#if os(iOS)
            if #available(iOS 14.0, *) {
                swiftyUIXExamplesApp.main()
            }
            else {
                UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(SceneDelegate.self))
            }
#elseif os(macOS)
            swiftyUIXExamplesApp.main()
#endif
        }
    }

//@main3
struct swiftyUIXExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
