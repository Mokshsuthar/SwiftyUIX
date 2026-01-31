//
//  AllFontsListView.swift
//  swiftyUIXExamples
//
//  Created by Moksh on 31/01/26.
//

import SwiftUI
import SwiftyUIX

struct AllFontsListView: View {
    struct FontModel : Identifiable {
        let id: UUID = UUID()
        var family: String
        var fonts: [String]
        
    }
    
    @State var allFontList: [FontModel] = []
    
    
    var body: some View {
        VStack {
        List {
                ForEach(allFontList) { family in
                    Section(header: Text(family.family).font(.headline)) {
                        ForEach(family.fonts, id: \.self) { fontName in
                            Text(fontName)
                                .font(.custom(fontName, size: 18)) // 👈 apply font here
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
           

        }
        .fullFrame()
        .onAppear {
            let fontList = self.getAllFonts()
            for font in fontList {
                self.allFontList.append(.init(family: font.key, fonts: font.value))
            }
        }
    }
}

#Preview {
    AllFontsListView()
}
