//
//  ContentView.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 20/07/23.
//

import SwiftUI
import SwiftyUIX
//example views
struct ContentView: View {
    
    @ViewBuilder
    var HomeView: some View {
        NavigationStack {
            
            
            List {
                Section {
                    
                    NavigationLink("DuoTestView", destination: DuoTestView())
                    NavigationLink("Book reader (division)", destination: BookReaderExample())
                    NavigationLink("Extra check", destination: BouncyButtonExample())
                    NavigationLink("Frame extesions", destination: FrameExamples())
                    NavigationLink("Color Hex Code", destination: ColorHexCodeExample())
    #if os(iOS)
                    NavigationLink("Safe Area", destination: SafeAreaExample())
                    NavigationLink("screen Corner Radius", destination: ScreenCornerRadiusExample())
                    NavigationLink("Keyboard monitor", destination: KeyboardMonitorTest())
                    NavigationLink("Safe Glass view", destination: SafeGlassEffect())
                    NavigationLink("List of all fonts", destination: AllFontsListView())
                    NavigationLink("Variable blur view", destination: VeriableBlurView())
                   
    #endif
                    
                    #if os(iOS)
                    Button {
                        self.showDrop(title: "This is Drop", subtitle: "drop is Showing", icon: UIImage(systemName: "hand.thumbsup.fill"), action: nil, position : .top, accessibility: nil)
                    } label: {
                        Text("Show Drop ")
                    }
                    
                    Button {
                        self.showAlert(title: "Hello", message: "I'm your alert", actions: [
                            .init(title: "Okay", style: .default, handler: { _ in
                                print("Done")
                            })
                            ], preferredStyle: .alert)
                    } label: {
                        Text("Open Alert view")
                    }
                    
                    Button {
                        self.ShareSheet(activityItems: ["hello world"])
                    } label: {
                        Text("Open Share sheet")
                    }
                    
                  #endif
                    
                } header: {
                    Text("Use of Extension")
                }

                

              
            }
            .navigationTitle("SwiftyUIX")
        }
    }
    
 
    var body: some View {

        HomeView
//        DuoTestView()
        
//        if #available(iOS 18.0, *) {
//            TabView {
//                Tab("Home", systemImage: "tray.and.arrow.down.fill") {
//                    HomeView
//                }
////                    .badge(2)
//                
//                
//                Tab("Sent", systemImage: "tray.and.arrow.up.fill") {
//                    EmptyView()
//                }
//                
//                
//                Tab("Account", systemImage: "person.crop.circle.fill") {
//                    EmptyView()
//                }
////                    .badge("!")
//            }
//            .toolbar {
//                Group{
//                    Button(action: {}) {
//                        systemImage("xmark")
//                    }
//                  
//                    
//                    Button(action: {}) {
//                        systemImage("figure.run")
//                    }
//                }
//                
//                Group{
//                    Button(action: {}) {
//                        systemImage("xmark")
//                    }
//                  
//                    
//                    Button(action: {}) {
//                        systemImage("figure.run")
//                    }
//                }
//               
//            }
//        } else {
//            HomeView
//        }
//        
       
//        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
