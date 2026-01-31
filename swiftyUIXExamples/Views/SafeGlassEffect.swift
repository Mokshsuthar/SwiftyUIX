//
//  SafeGlassEffect.swift
//  swiftyUIXExamples
//
//  Created by Moksh on 31/01/26.
//

import SwiftUI
import SwiftyUIX

struct SafeGlassEffect: View {
    let columnCount: Int = 6
    let gridSpacing: CGFloat = 16.0
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: gridSpacing), count: columnCount), spacing: gridSpacing) {
                ForEach(0...100,id: \.self) { index in
                    systemImage("swift")
                        .foregroundColor(Color.black)
                        .aspectRatio(contentMode: .fit)
                        .squareFrame(size: 40)
                        .opacity(0.2)
                }
            }
            
            
            VStack {
                
                if #available(iOS 15.0, *) {
                    Text("Safe clear glass with Blur view")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(Color.black)
                        .padding()
                        .safe_glassEffect(.clear, .ultraThin, isintractive: true, clipShape: .capsule, tintColor: nil)
                    
                    
                    Text("Safe regular glass with Blur view")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(Color.black)
                        .padding()
                        .safe_glassEffect(.regular, .ultraThin, isintractive: true, clipShape: .capsule, tintColor: nil)
                    
                    
                    Text("Safe clear glass with Blur view and tint")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(Color.black)
                        .padding()
                        .safe_glassEffect(.clear, .ultraThin, isintractive: true, clipShape: .capsule, tintColor: Color.purple.opacity(0.4))
                    
                    
                } else {
                    // Fallback on earlier versions
                }
                
              
                
            }
            .padding()
        }
        .fullFrame()
        .background(Color(hexString: "F2F2F2"))
        .ignoreSafeArea_C()
    }
}

#Preview {
    SafeGlassEffect()
}
