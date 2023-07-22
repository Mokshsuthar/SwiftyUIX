//
//  BorderView.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

import SwiftUI

struct BorderView: View {
    var radius : CGFloat
    var lineWidth : CGFloat
    var color : Color
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .strokeBorder(color,lineWidth: lineWidth)
    }
}
