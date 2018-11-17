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

    
    static let shared = WebView()
    
    var wkWebView = WKWebView()
    let userContentController = WKUserContentController()
    
    var delegate: UIViewControllerDelegate?
    
    var path = ""
    
    override init() {
        super.init()
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.wkWebView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        
        userContentController.add(self, name: "pushToNext")
        userContentController.add(self, name: "dismissView")
        userContentController.add(self, name: "presentView")
        userContentController.add(self, name: "setNavTitle")
        userContentController.add(self, name: "showNavBar")
        userContentController.add(self, name: "hideNavBar")
        userContentController.add(self, name: "setNavBarBackground")
        userContentController.add(self, name: "setTabBarTint")
        userContentController.add(self, name: "setTitleFont")
        userContentController.add(self, name: "toggleScrolling")
        
        wkWebView.scrollView.isScrollEnabled = false
        wkWebView.navigationDelegate = self
        
        print("Loading: index.html#!\(path)")
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        wkWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }
    
}
protocol UIViewControllerDelegate {
    func pushViewController(path: String?)
    func presentViewController(path: String?)
    func dismissViewController()
    func setNavigationBar(title: String?)
    func setScrolling(enabled: Bool)
    func setTabBarTint(color: UIColor)
    func setTitleFont(with: [String: Any]?)
    func showNavBar()
    func hideNavBar()
    func setNavBarBackground(image: String)
    
    
    func doneLoading(withWebView: WKWebView)
}


extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigation b.")
        delegate?.doneLoading(withWebView: self.wkWebView)
    }
}


extension WebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Executing: \(message.name)")
        switch message.name {
        case "pushToNext":
            delegate?.pushViewController(path: message.body as? String)
            break
        case "dismissView":
            delegate?.dismissViewController()
            break
        case "presentView":
            delegate?.presentViewController(path: message.body as? String)
            break
        case "setNavTitle":
            delegate?.setNavigationBar(title: message.body as? String)
            break
        case "showNavBar":
            delegate?.showNavBar()
            break
        case "hideNavBar":
            delegate?.hideNavBar()
            break
        case "setNavBarBackground":
            delegate?.setNavBarBackground(image: message.body as? String ?? "canada-150-cover")
            break
        case "setTabBarTint":
            let color = UIColor.color(from: message.body as? String ?? "#ff2d55")
            delegate?.setTabBarTint(color: color)
            break
        case "setTitleFont":
            delegate?.setTitleFont(with: message.body as? [String: Any])
            break
        case "toggleScrolling":
            delegate?.setScrolling(enabled: message.body as? Bool ?? true)
            break
        default:
            print("Default Caught.")
//            delegate?.pushViewController(path: message.body as? String)
        }
    }
}
