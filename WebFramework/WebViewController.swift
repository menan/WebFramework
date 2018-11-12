//
//  WebViewController.swift
//  WebFramework
//
//  Created by Menan Vadivel on 2018-11-11.
//  Copyright © 2018 Owl Home Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView?
    let userContentController = WKUserContentController()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
        userContentController.add(self, name: "pushToNext")
        userContentController.add(self, name: "dismiss")
        userContentController.add(self, name: "present")
        userContentController.add(self, name: "setTitle")
        userContentController.add(self, name: "toggleSidebar")
        
        
        self.view = self.webView
        
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
        
        
        webView?.scrollView.isScrollEnabled = false
        
        
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        webView?.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
    func pushToNext() {
        
        let viewController = WebViewController()
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func presentView() {
        
        let viewController = WebViewController()
        
        self.present(viewController, animated: true) {
            print("Its done.")
        }
    }
    func dismissView() {
        self.dismiss(animated: true) {
            print("Its done.")
        }
    }
    
    func setTitle(title: String) {
        
        var vc: UIViewController!
        if parent is TabBarViewController {
            vc = parent
        }
        else {
            vc = self
        }
        vc.title = title
    }
    
    
    func toggleSidebar() {
        //show or hide left bar button item
        var vc: UIViewController!
        if parent is TabBarViewController {
            vc = parent
        }
        else {
            vc = self
        }
        
        if vc.navigationItem.leftBarButtonItem == nil {
            let menu = UIBarButtonItem(image: UIImage(named: "menu-icon"), style: .plain, target: self, action: #selector(sidebarToggled))
            vc.navigationItem.leftBarButtonItem  = menu
        }
        else {
            vc.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func sidebarToggled() {
        
    }

}


extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "test", let messageBody = message.body as? String {
            print(messageBody)
        }
        else if message.name == "pushToNext", let messageBody = message.body as? String {
            pushToNext()
            print("Pushing: \(messageBody)")
        }
        else if message.name == "dismiss", let messageBody = message.body as? String {
            dismissView()
            print("Dimissing: \(messageBody)")
        }
        else if message.name == "present", let messageBody = message.body as? String {
            presentView()
            print("Presenting: \(messageBody)")
        }
        else if message.name == "setTitle", let messageBody = message.body as? String {
            setTitle(title: messageBody)
        }
        else if message.name == "toggleSidebar", let messageBody = message.body as? String {
            toggleSidebar()
            print("Toggling side bar: \(messageBody)")
        }
    }
}
