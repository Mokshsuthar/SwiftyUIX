//
//  windowNavigationButtons.swift
//  MyDrive
//
//  Created by Moksh on 21/04/24.
//

#if os(macOS)
  
import Foundation
import SwiftUI

public typealias VoidClosure = () -> Void

public struct windowButtons: View {
    @State var isHover : Bool = false
    @State  var isFullScreen = false
    var closeHandler : VoidClosure
    var miniaturizeHandler : VoidClosure?
    var resizeHandler : VoidClosure?
    
    public init(closeHandler: @escaping VoidClosure, miniaturizeHandler: VoidClosure? = nil, resizeHandler: VoidClosure? = nil) {
       self.closeHandler = closeHandler
       self.miniaturizeHandler = miniaturizeHandler
       self.resizeHandler = resizeHandler
    }
    
   
    
    @ViewBuilder
    var closeButton: some View {
        ZStack{
            if isHover{
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(Color.black.opacity(0.5))
                    .font(.system(size: 10,weight: .bold,design: .rounded))
                    .squareFrame(size: 6.5)
                    
            }
            
        }
        .squareFrame(size: 12)
        .background(Color(hexString: "#FE5F57"))
        .cornerRadius(6)
        .onHover { isHover in
            self.isHover = isHover
        }
        .onTapGesture {
            self.closeHandler()
        }
    }
    
    
    @ViewBuilder
    var miniaturizeButton: some View {
        ZStack{
            if isHover{
                if !isFullScreen {
                    Image(systemName: "minus")
                        .foregroundColor(Color.black.opacity(0.5))
                        .font(.system(size: 10,weight: .bold,design: .rounded))
                        .padding(3)
                        .fullFrame()
                }
            }
            
        }
        .squareFrame(size: 12)
        .background(isFullScreen ? Color.gray : Color(hexString: "#FEBC2E"))
        .cornerRadius(6)
        .onHover { isHover in
             self.isHover = isHover
        }
        .onTapGesture {
            if !isFullScreen {
                self.miniaturizeHandler?()
            }
        }
        
    }
    
    
    @ViewBuilder
    var resizeButton: some View {
        ZStack{
            if isHover{
                Image(systemName: "arrowtriangle.up.fill")
                    .resizable()
                    .foregroundColor(Color.black.opacity(0.5))
                    .font(.system(size: 8,weight: .bold,design: .rounded))
                    .squareFrame(size: 8)
                    .scaleEffect(x : 2)
                    .scaleEffect(0.4, anchor: .top)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .foregroundColor(Color.black.opacity(0.5))
                    .font(.system(size: 8,weight: .bold,design: .rounded))
                    .squareFrame(size: 8)
                    .scaleEffect(x : 2)
                    .scaleEffect(0.4, anchor: .bottom)
            }
            
        }
        .rotationEffect(.degrees(-45))
        .squareFrame(size: 12)
        .background(Color(hexString: "#28C840"))
        .cornerRadius(6)
        .onHover { isHover in
            self.isHover = isHover
        }
        .onTapGesture {
            isFullScreen.toggle()
            self.resizeHandler?()
        }
    }
    
    
    public var body: some View {
        HStack(spacing : 8){
            
            closeButton
            
            if let miniaturizeHandler {
                miniaturizeButton
            } else {
                Circle()
                    .fill(Color.gray)
                    .squareFrame(size: 12)
            }
            
            
            if let resizeHandler {
                resizeButton
            } else {
                Circle()
                    .fill(Color.gray)
                    .squareFrame(size: 12)
            }
           
            Spacer(minLength: 0)
        }
    }
}

#endif
