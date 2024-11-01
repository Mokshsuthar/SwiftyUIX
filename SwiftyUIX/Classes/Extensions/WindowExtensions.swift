//
//  WindowExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh on 31/10/24.
//

#if os(macOS)
import AppKit

extension NSWindow {
    func transparentWindow(level : NSWindow.Level) {
        self.styleMask = .borderless
        self.backingType = .buffered
        self.backgroundColor = .clear
        self.hasShadow = false
        self.styleMask.insert(.borderless)
        self.level = .screenSaver
    }
}

#endif
