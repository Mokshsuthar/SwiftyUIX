//
//  ColorHexCodeExample.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 21/07/23.
//

import SwiftUI
import SwiftyUIX

struct ColorHexCodeExample: View {
    @State var hexCode  : String = "7A9D54"
    var body: some View {
        VStack{
            ZStack{
                ZStack{
                    Text("Color Code = \(hexCode)")
                }
                .squareFrame(size: 200)
                .background(Color(hexString: hexCode))
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
              
            }.fullFrame()
            
            
            VStack{
                Text("Color hex Code")
                    .fullWidth(alignment: .leading)
                
                TextField("Enter Hex Code like #b1b1b1", text: $hexCode)
                    .font(.headline.lowercaseSmallCaps())
                    .padding(10)
                    .fullWidth(height: 40,alignment: .leading)
                    .background(Color.blackWhite.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct ColorHexCodeExample_Previews: PreviewProvider {
    static var previews: some View {
        ColorHexCodeExample()
    }
}
