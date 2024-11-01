//
//  SafeAreaExample.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 21/07/23.
//

import SwiftUI
import SwiftyUIX

#if os(iOS)
struct SafeAreaExample: View {
    
    @State var topSafeAreaShow : Bool = false
    @State var bottomSafeAreaShow : Bool = false
    var body: some View {
        VStack(spacing : 0){
            if topSafeAreaShow{
                Spacer()
                    .topSafeArea()
            }
            
            ZStack{
                Image("semple")
                    .resizable().aspectRatio(contentMode: .fill)
                    .fullFrame()
                
                VStack{
                    
                   
                    HStack{
                        Text("Top safe Area")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .fullWidth(alignment: .leading)
                        
                        Toggle("", isOn: $topSafeAreaShow)
                    }
                    .padding()
                    .fullWidth(height: 50)
                    
                    Divider()
                    
                    HStack{
                        Text("Bottom safe Area")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .fullWidth(alignment: .leading)
                        
                        Toggle("", isOn: $bottomSafeAreaShow)
                    }
                    .padding()
                    .fullWidth(height: 50)
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding()
            }
            .fullFrame()
            .clipped()
            
            
            if bottomSafeAreaShow{
                Spacer()
                    .bottomSafeArea()
            }
        }.fullFrame()
        .ignoreSafeArea_C()
    }
}

struct SafeAreaExample_Previews: PreviewProvider {
    static var previews: some View {
        SafeAreaExample()
    }
}

#endif
