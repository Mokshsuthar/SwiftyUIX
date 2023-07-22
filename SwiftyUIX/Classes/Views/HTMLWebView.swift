//
//  WebView.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

import SwiftUI
import WebKit
#if os(iOS)
import UIKit


// WebViewFromHTML is a SwiftUI UIViewRepresentable that displays a WKWebView with HTML content from a specified file path.
// It provides a way to load HTML content into the WKWebView and handle scrolling events.
// You can also optionally receive scroll events through the 'scrollviewDidScroll' closure parameter.
//Example : HTMLWebView(filePath : Bundle.main.path(forResource: filename, ofType: "html"))

struct HTMLWebView: UIViewRepresentable {
    @State var filePath: String
    var scrollViewDidScroll: ((CGFloat) -> Void)? = nil
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.delegate = context.coordinator
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            uiView.loadHTMLString(contents, baseURL: baseUrl)
        } catch {
            print("Error loading HTML file.")
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: HTMLWebView
        
        init(parent: HTMLWebView) {
            self.parent = parent
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            // You can handle additional actions here when the scroll view finishes decelerating.
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // Pass the content offset value to the closure if it's provided.
            parent.scrollViewDidScroll?(scrollView.contentOffset.y)
        }
    }
}

#endif

#if os(macOS)
import AppKit
struct HTMLWebView: NSViewRepresentable {
    @State var filePath: String
    
    func makeNSView(context: Context) -> WKWebView {
        let WebView = WKWebView()
        return WebView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        do {
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            
            nsView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
    }
}

#endif
