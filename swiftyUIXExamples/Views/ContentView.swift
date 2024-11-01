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
 
    var body: some View {
        VStack{
          
            
            NavigationView {
                List {
                    Section {
                        
                        NavigationLink("Frame extesions", destination: FrameExamples())
                        NavigationLink("Color Hex Code", destination: ColorHexCodeExample())
#if os(iOS)
                        NavigationLink("Safe Area", destination: SafeAreaExample())
                        NavigationLink("screen Corner Radius", destination: ScreenCornerRadiusExample())
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
                
              
                
               
            }
            .navigationTitle("SwiftyUIX")
        }
        .background(Color.red)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
