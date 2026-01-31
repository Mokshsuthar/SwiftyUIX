//
//  KeyboardMonitorTest.swift
//  swiftyUIXExamples
//
//  Created by Moksh on 31/01/26.
//

import SwiftUI
import Combine
import SwiftyUIX

struct KeyboardMonitorTest: View {
    @State var text: String = ""
    @State var keyboardHeight: CGFloat = 0
    
    @StateObject var keyboardMonitor = KeyboardMonitorTestViewModel()
//    @StateObject var keyboardMonitor = KeyboardMonitor.shared
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                
                TextField("Hello", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .fullWidth(height: 60)
                    .ignoresSafeArea(.keyboard)
                
                Spacer()
                    .bottomSafeArea( plus: keyboardMonitor.height)
            }
        }
        .padding()
        .fullFrame()
        .ignoresSafeArea()
       
    }
}

#Preview {
    KeyboardMonitorTest()
}



class KeyboardMonitorTestViewModel: ObservableObject {
    @Published var height: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        KeyboardMonitor.shared.heightPublisher
                   .removeDuplicates()
                   .assign(to: \.height, on: self) // iOS 13 OK
                   .store(in: &cancellables)
    }
}
