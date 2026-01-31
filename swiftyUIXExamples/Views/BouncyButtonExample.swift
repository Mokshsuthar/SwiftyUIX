//
//  BouncyButtonExample.swift
//  swiftyUIXExamples
//
//  Created by Moksh on 06/11/25.
//

import SwiftUI
import SwiftyUIX
import StoreKit

struct BouncyButtonExample: View {
    var body: some View {
        ZStack{
            Button(action: {
//                SKStoreReviewController().requestReviewInCS()
//                self.playHapticFeedback(.levelChange)
            }) {
                Text("Tap me \(Int64(232))")
                    .font(.headline)
                    .padding(.horizontal,10)
                    .padding(.vertical,5)
                    .background(Color.blue)
                    .cornerRadius(30)
                    
            }
            .buttonStyle(.borderless)
//            .buttonStyle(.)
        }
        .navigationTitle("Bouncy Button")
    }
}

#Preview {
    BouncyButtonExample()
}
