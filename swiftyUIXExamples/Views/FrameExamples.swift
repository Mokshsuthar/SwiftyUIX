//
//  FrameExamples.swift
//  swiftyUIXExamples
//
//  Created by Moksh Suthar on 20/07/23.
//

import SwiftUI

struct FrameExamples: View {
    //    @State var sizeValue
    @State var selectedFrameCase : frameCase = .fullWidth
    @State var selectedAlignment : Alignment = .center
    @State var sizeValue : CGFloat = 300
    var body: some View {
        VStack(spacing : 0){
            ZStack{
                switch selectedFrameCase {
                case .fullframe:
                    Text(selectedFrameCase.rawValue)
                        .fullframe()
                        .background(Color.red)
                case .fullWidth:
                    Text("\(selectedFrameCase.rawValue)\n fullWidth X \(String(format: "%.0f", sizeValue))")
                        .fullWidth(height: sizeValue)
                        .background(Color.red)
                        .multilineTextAlignment(.center)
                case .fullHeight:
                    Text("\(selectedFrameCase.rawValue)\n \(String(format: "%.0f", sizeValue)) X fullHeight")
                        .fullHeight(width: sizeValue)
                        .background(Color.red)
                        .multilineTextAlignment(.center)
                case .squreFrame:
                    Text("\(selectedFrameCase.rawValue)\n \(String(format: "%.0f", sizeValue)) X \(String(format: "%.0f", sizeValue))")
                        .squareFrame(size: sizeValue)
                        .background(Color.red)
                }
                
            }
            .fullframe()
            .background(Color.blackWhite.opacity(0.1))
            
            VStack{
                HStack{
                   Text("Extensions")
                        .fullWidth(alignment: .leading)
                    
                    Picker("", selection: $selectedFrameCase) {
                        ForEach(frameCase.allCases, id: \.self) { frameCase in
                            Text(frameCase.rawValue)
                        }
                    }
                }
                
               
                
                if selectedFrameCase != .fullframe {
                    VStack{
                        HStack{
                            Text(getSizeTitle())
                            
                            Spacer()
                            
                            Text("\(String(format: "%.0f", sizeValue))")
                            
                        }
                        
                        Slider(value: $sizeValue, in: 70...351, step: 20)
                    }
                }
              
              
            }
            .padding()
            
        }
    }
    
    func getSizeTitle() -> String {
        
        switch selectedFrameCase {
        case .fullframe:
            return ""
        case .fullWidth:
            return "Height"
        case .fullHeight:
            return "width"
        case .squreFrame:
            return "size"
        }
        
       
    }
    
   
}

struct FrameExamples_Previews: PreviewProvider {
    static var previews: some View {
        FrameExamples()
    }
}

enum frameCase : String,CaseIterable{
    case fullframe = "Full frame"
    case fullWidth = "Full width"
    case fullHeight = "Full height"
    case squreFrame = "Squre Frame"
}
