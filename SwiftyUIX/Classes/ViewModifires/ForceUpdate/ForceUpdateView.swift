//
//  ForceUpdateView.swift
//  SwiftyUIX
//
//  Created by Moksh on 05/11/24.
//

import SwiftUI

struct ForceUpdateView: View {
    @ObservedObject var model : ForceUpdateViewController
     var body: some View {
         ZStack{
             
             
             VStack{
                 ZStack{
                     VStack(spacing : 20){
                         ForEach(1...9, id: \.self){ indexI in
                             HStack(spacing : 20){
                                 ForEach(11...19,id: \.self){ indexJ in
                                     if indexI == 5 && indexJ == 15 {
                                         ZStack{
                                             if let appIcon = UIApplication.shared.appIcon {
                                                 Image(uiImage: appIcon)
                                                     .resizable().aspectRatio(contentMode: .fit)
                                                     .fullFrame()
                                             } else {
                                                 systemImage("sparkles")
                                                     .padding(14)
                                                     .fullFrame()
                                             }
                                         }
                                         .squareFrame(size: 90)
                                         .background(Color.secondary.opacity(0.3))
                                         .cornerRadius(18)
                                         .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 0)
                                        
                                     } else{
                                         RoundedRectangle(cornerRadius: 18, style: .continuous)
                                             .fill(Color.secondary.opacity(0.1))
                                             .squareFrame(size: 90)
                                     }
                                 }
                             }
                         }
                     }
                    
                 }
                 .fullFrame()
                 .mask (
                     VStack(spacing : 0){
                         Rectangle()
                         LinearGradient(colors: [Color.white,Color.white.opacity(0)], startPoint: .top, endPoint: .bottom)
                     })
                
                 VStack(spacing : 30){
                     VStack{
                         Text("New Version Available")
                             .font(.system(size: 25,weight: .heavy))
                             .multilineTextAlignment(.center)
                             .padding(.horizontal)
                             .fullWidth(alignment: .center)
                         
                         Text("Please Update your app with new version to continue")
                             .font(.headline)
                             .fontWeight(.regular)
                             .multilineTextAlignment(.center)
                             .padding(.horizontal)
                             .fullWidth(alignment: .center)
                     }
                     
                   
                     Button(action: model.updateAction) {
                         Text("Update")
                             .font(.headline)
                             .foregroundColor(Color.white)
                             .fullWidth(height: 60)
                             .background(Color.accentColor)
                             .cornerRadius(30)
                             .padding(.horizontal,30)
                     }
                 }
                
                 
                 
                 Spacer()
                     .bottomSafeArea(plus: 30, ifZero: 16)
                 
             }
             
             if model.showCloseButton {
                 VStack{
                     Spacer()
                         .topSafeArea()
                     
                     HStack{
                         Spacer()
                         
                         Button(action: model.closeAction) {
                             systemImage("xmark")
                                 .foregroundColor(Color.black)
                                 .font(.system(size: 30,weight: .heavy))
                                 .padding(8)
                                 .squareFrame(size: 30)
                                 .background(Color.white)
                                 .cornerRadius(15)
                         }
                     }
                     .padding(.horizontal)
                     Spacer()
                     
                 }
             }
             
            
         }
         .fullFrame()
         .background(BlurView(style: .regular))
         .ignoreSafeArea_C()
      
    }
}


