//
//  swiftyUIXExamplesApp.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 20/07/23.
//

import SwiftUI
import SwiftyUIX

//@main
//    struct WeatherProAppWrapper {
//        static func main() {
//#if os(iOS)
//            if #available(iOS 14.0, *) {
//                swiftyUIXExamplesApp.main()
//                    
//            } else {
//                UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(SceneDelegate.self))
//            }
//#elseif os(macOS)
//            swiftyUIXExamplesApp.main()
//#endif
//        }
//    }

@main
struct swiftyUIXExamplesApp: App {
    @State private var layoutInspector = LayoutInspector.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                
                ContentView()
                    .environment(layoutInspector)
                    .onAppear{
                    #if os(iOS)
                        forceUpdateModel.shared.checkVersion(appID: "1599080641",showCloseButton: false)
                    #endif
                    }
                
                LayoutInspectionView()
                    
                   
            }
           
        }
        
    }
}
