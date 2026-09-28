//
//  VeriableBlurView.swift
//  swiftyUIXExamples
//
//  Created by Moksh on 31/01/26.
//

import SwiftUI
import SwiftyUIX

enum BlurCases: String, CaseIterable {
    case none = "None"
    case vertical = "Vertical"
    case horizontal = "Horizontal"
}

struct VeriableBlurView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State var blurCases: BlurCases = .vertical
    
    
    
    @State var applyMask: Bool = true
    
    
    @ViewBuilder
    var verticalScrollView : some View {
        ScrollView(.vertical) {
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
            
        }
        .safeAreaPadding(.top, self.topSafeAreaHeight + 66)
        .safeAreaPadding(.bottom, self.bottomSafeAreaHeight(plus: 66))
        
        .mask {
            ZStack{
                if applyMask {
                    switch blurCases {
                    case .vertical:
                        VStack(spacing: 0){
                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .top, endPoint: .bottom)
                                .fullWidth(height: self.topSafeAreaHeight(plus: 66))
                            
                           Rectangle()
                            
                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .bottom, endPoint: .top)
                                .fullWidth(height: self.bottomSafeAreaHeight(ifZero: 16,plus: 66))
                        }
                            .transition(.blurReplace)
                    case .horizontal:
                        HStack(spacing: 0){
                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .leading, endPoint: .trailing)
                                .fullHeight(width: 50)
                            
                           Rectangle()
                            
                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .trailing, endPoint: .leading)
                                .fullHeight(width: 50)
                        }
                            .transition(.blurReplace)
                    case .none:
                        Rectangle()
                    }
                } else {
                    Rectangle()
                }
              
            }
            .allowsHitTesting(false)
        }
        
    }
    
    
    
    
    
    @ViewBuilder
    var VerticalOverlayView : some View {
        VStack{
            VariableBlurView(maxBlurRadius: 3, direction: .blurredTopClearBottom)
           
            Spacer()
            
            VariableBlurView(maxBlurRadius: 3, direction: .blurredBottomClearTop)
                .fullWidth(height: self.bottomSafeAreaHeight(plus: 100))
            
            
        }
    }
    
    @ViewBuilder
    var horizontalScrollView : some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading, content: {
                HStack{
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
                .fullHeight()
                
                HStack{
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
                 .fullHeight()
            })
            .padding(.vertical)
            
        }
//        .safeAreaPadding(.top, self.topSafeAreaHeight + 66)
        .safeAreaPadding(.horizontal, self.bottomSafeAreaHeight(ifZero: 16))
        .safeAreaPadding(.bottom, 116)
      
//        .ignoreSafeArea_C()
        
    }
    
    @ViewBuilder
    var HorizontalOverlayView : some View {
        HStack{
            VariableBlurView(maxBlurRadius: 3, direction: .blurredLeftClearRight)
                .fullHeight(width: self.bottomSafeAreaHeight(ifZero: 16))
            
            
            Spacer()
            
            VariableBlurView(maxBlurRadius: 3, direction:  .blurredRightClearLeft)
                .fullHeight(width: 101)
            
            
        }
    }
    
    
    var body: some View {
        ZStack{
            ZStack{
                
                switch blurCases {
                case .vertical:
                    verticalScrollView
                        .ignoresSafeArea(edges: .vertical)
                    VerticalOverlayView
                        .ignoresSafeArea()
                        .transition(.blurReplace)
                case .horizontal:
                    horizontalScrollView
//
                        .mask {
                            ZStack{
                                if applyMask {
                                    switch blurCases {
                                    case .vertical:
                                        VStack(spacing: 0){
                                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .top, endPoint: .bottom)
                                                .fullWidth(height: self.topSafeAreaHeight(plus: 66))
                                            
                                           Rectangle()
                                            
                                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .bottom, endPoint: .top)
                                                .fullWidth(height: self.bottomSafeAreaHeight(ifZero: 16,plus: 66))
                                        }
                                            .transition(.blurReplace)
                                    case .horizontal:
                                        HStack(spacing: 0){
                                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .leading, endPoint: .trailing)
                                                .fullHeight(width: 50)
                                            
                                           Rectangle()
                                            
                                            LinearGradient(colors: [Color.clear,Color.white], startPoint: .trailing, endPoint: .leading)
                                                .fullHeight(width: 101)
                                        }
                                            .transition(.blurReplace)
                                    case .none:
                                        Rectangle()
                                    }
                                } else {
                                    Rectangle()
                                }
                              
                            }
                            .allowsHitTesting(false)
                            .ignoresSafeArea()
                        }
                    HorizontalOverlayView
                        .ignoresSafeArea()
                        .transition(.blurReplace)
                case .none:
                    verticalScrollView
                        .ignoresSafeArea(edges: .vertical)
                }
            }
            .animation(.smooth, value: blurCases)
         
            
            VStack {
                Spacer()
                
                
                VStack{
                    Toggle(isOn: $applyMask) {
                        Text("Apply Mask")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    
                    Divider()
                    
                    Picker(selection: $blurCases) {
                        ForEach(BlurCases.allCases,id: \.self){ blurType in
                            Text(blurType.rawValue)
                                .font(.headline)
                        }
                    } label: {
                        Text("Blur Type")
                    }
                    .pickerStyle(.segmented)
                    .controlSize(.large)
                    .padding(.horizontal, 12)
                }
                .padding(.vertical, 12)
                .safeGlassEffect(.regular, fallback: Color.white, isInteractive: true, clipShape: RoundedRectangle(cornerRadius: self.screenCornerRadius(minimum: self.bottomSafeAreaHeight(ifZero: 16) + 10) - self.bottomSafeAreaHeight(ifZero: 16)))
                
                
//
//                
//
            }
            .padding(.horizontal,self.bottomSafeAreaHeight(ifZero: 16))
//            .ignoreSafeArea_C()
        }
//
        .fullFrame()
        
    }
}

#Preview {
    VeriableBlurView()
}
