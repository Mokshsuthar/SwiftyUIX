//
//  VeriableBlurView.swift
//  swiftyUIXExamples
//
//  Created by Moksh on 31/01/26.
//

import SwiftUI
import SwiftyUIX

struct VeriableBlurView: View {
    
    @State var showVariableBlur: Bool = true
    
    
    @ViewBuilder
    var scrollView : some View {
        ScrollView(.vertical) {
            VStack{
                Spacer()
                    .topSafeArea()
                HStack(alignment: .top, content: {
                    VStack{
                        Image(.car1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car3)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car5)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car7)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car2)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car4)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car6)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }
                    .fullWidth()
                    
                    VStack{
                        Image(.car2)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car4)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car6)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car3)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                        Image(.car5)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                    }
                    .fullWidth()
                })
                .padding(.horizontal)
                
                Spacer()
                    .bottomSafeArea()
            }
            
            
            
        }
        
    }
    
    @ViewBuilder
    var overlayView : some View {
        VStack{
            variableBlurViewWithBackground(maxBlurRadius: 3, direction: .blurredTopClearBottom, linearGradientColors: [Color.blackWhite.opacity(0.2),Color.blackWhite.opacity(0)])
                .fullWidth(height: self.topSafeAreaHeight(plus: 40))
            
            
            Spacer()
            
            variableBlurViewWithBackground(maxBlurRadius: 3, direction: .blurredBottomClearTop, linearGradientColors: [Color.blackWhite.opacity(0.2),Color.blackWhite.opacity(0)])
                .fullWidth(height: self.bottomSafeAreaHeight(plus: 100))
            
            
        }
    }
    
    
    var body: some View {
        ZStack{
            scrollView
            
            if showVariableBlur {
                overlayView
            }
         
            
            VStack {
                Spacer()
                
                Toggle(isOn: $showVariableBlur) {
                    Text("Toggle Variable Blur")
                }
                .padding()
                .safe_glassEffectWithFallBackColor(.regular, Color.white, isintractive: true, clipShape: .capsule, tintColor: nil, glassEffectID: nil)
                .padding(.horizontal)
               
                
                Spacer()
                    .bottomSafeArea()
            }
        }
        .ignoreSafeArea_C()
        .fullFrame()
        
    }
}

#Preview {
    VeriableBlurView()
}
