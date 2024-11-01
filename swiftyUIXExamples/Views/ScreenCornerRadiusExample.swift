//
//  ScreenCornerRadiusExample.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 21/07/23.
//


#if os(iOS)
import SwiftUI
import SwiftyUIX
struct ScreenCornerRadiusExample: View {
    
    @State var padding : CGFloat = 10
    
    var body: some View {
        ZStack{
            VStack{
//                Spacer()
                
                VStack(spacing : 16){
                    Spacer()
                        .topSafeArea(plus: -(padding + 16))
                    
                    Text("Device screen Corner Radius")
                        .font(.headline)
                        .fullWidth(alignment : .leading)
                    
                    Text("The function screenCornerRadius(minimum: CGFloat = 0) -> CGFloat is a utility function in Swift that calculates the corner radius of the device's screen based on the display's physical curvature. It takes an optional parameter minimum of type CGFloat, which sets a minimum corner radius value that the function will not go below. If no value is provided for minimum, it defaults to 0.")
                        .font(.subheadline)
                        .fullWidth()
                    
                }
                .padding(30)
                .fullWidth()
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
                
                VStack(spacing : 16){
                  
                    HStack{
                        Text("Padding")
                            .font(.headline)
                            .fullWidth(alignment: .leading)
                        
                        Text("\(String(format: "%.1f", padding))")
                    }
                    
                    Slider(value: $padding, in: 0...30)
                }
                .padding(30)
                .fullWidth()
                .background(Color.white)
                .cornerRadius(10)
               
            }
            .cornerRadius(self.screenCornerRadius() - padding)
            .padding(padding)
        }
        .fullFrame()
        .background(Color.black.opacity(0.2))
        .ignoreSafeArea_C()
        .preferredColorScheme(.light)
    }
}

struct ScreenCornerRadiusExample_Previews: PreviewProvider {
    static var previews: some View {
        ScreenCornerRadiusExample()
    }
}
#endif
