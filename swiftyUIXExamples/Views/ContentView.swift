//
//  ContentView.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 20/07/23.
//

import SwiftUI
import SwiftyUIX

struct ContentView: View {

    var body: some View {
        VStack{
          
            
            NavigationView {
                List {
                    Section {
                        NavigationLink("Frame extesions", destination: FrameExamples())
                        NavigationLink("Color Hex Code", destination: ColorHexCodeExample())
                        
                        NavigationLink("Safe Area", destination: SafeAreaExample())
                        NavigationLink("screen Corner Radius", destination: ScreenCornerRadiusExample())
                        #if os(iOS)
                        Text(Date().getShortMonthName())
                        #endif

                    } header: {
                        Text("Use of Extention")
                    } footer: {
                        Text("Use of Extention")
                    }

                    

                  
                }
                
               
            }
            .navigationTitle("SwiftyUIX")
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
