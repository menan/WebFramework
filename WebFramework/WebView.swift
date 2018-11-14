//
//  WebView.swift
//  WebFramework
//
//  Created by Menan Vadivel on 2018-11-13.
//  Copyright © 2018 Owl Home Inc. All rights reserved.
//

import UIKit
import WebKit

class WebView: NSObject {

    var webView: WKWebView!
    let userContentController = WKUserContentController()
    
    convenience override init() {
        self.init(with: WKWebView())
    }
    
    init(with webView: WKWebView) {
        self.webView = webView
    }
    
}
