//
//  WebView.swift
//  WebFramework
//
//  Created by Menan Vadivel on 2018-11-13.
//  Copyright © 2018 Owl Home Inc. All rights reserved.
//

import UIKit
import WebKit
import Actions

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
    
    func replaceButtons() {
        self.wkWebView.evaluateJavaScript("document.getElementsByClassName('button').length") { (res, err) in
            if let length = res as? Int {
                print("There are \(length) buttons")
                for i in 0...length-1 {
                    
                    let element = "document.getElementsByClassName('button')[\(i)]"
                    
                    self.wkWebView.evaluateJavaScript("\(element).innerHTML") { (res, err) in
                        guard let innerHTML = res as? String else { return }
                        
                        self.wkWebView.evaluateJavaScript("\(element).offsetTop") { (res, err) in
                            guard let offsetTop = res as? Int else { return }
                            
                            self.wkWebView.evaluateJavaScript("\(element).offsetLeft") { (res, err) in
                                guard let offsetLeft = res as? Int else { return }
                                
                                self.wkWebView.evaluateJavaScript("\(element).offsetWidth") { (res, err) in
                                    guard let offsetWidth = res as? Int else { return }
                                    
                                    self.wkWebView.evaluateJavaScript("\(element).offsetHeight") { (res, err) in
                                        guard let offsetHeight = res as? Int else { return }
                                        
                                        
                                        
                                        let testSwtichFrame = CGRect(x: offsetLeft, y: offsetTop, width: offsetWidth, height: offsetHeight)
                                        let testSwitch = UIButton(frame: testSwtichFrame)
                                        testSwitch.setTitle(innerHTML, for: .normal)
                                        testSwitch.setTitleColor(.white, for: .normal)
                                        
                                        self.wkWebView.scrollView.addSubview(testSwitch)
                                        
                                        self.wkWebView.evaluateJavaScript("\(element).attributes.onclick.value") { (res, err) in
                                            guard let onClick = res as? String else { return }
                                            testSwitch.addAction {
                                                self.wkWebView.evaluateJavaScript(onClick) { (res, err) in
                                                    print("Button click res = \(res) err = \(err)")
                                                    
                                                }
                                            }
                                        }
                                        
                                        self.wkWebView.evaluateJavaScript("window.getComputedStyle(\(element), null).getPropertyValue('background-color')") { (res, err) in
                                            guard let backgroundColor = res as? String else { return }
                                            
                                            testSwitch.backgroundColor = UIColor.color(withRGBString: backgroundColor)
                                            
                                            self.wkWebView.evaluateJavaScript("window.getComputedStyle(\(element), null).getPropertyValue('border-radius')") { (res, err) in
                                                guard let borderRadius = res as? String else { return }
                                                
                                                
                                                if let radius = Int(borderRadius.replacingOccurrences(of: "px", with: "")) {
                                                    print("border radius: \(radius)")
                                                    testSwitch.layer.cornerRadius = CGFloat(radius)
                                                }
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                }
                
            }
        }
    }
    
    func replaceInput() {
        self.wkWebView.evaluateJavaScript("document.getElementsByClassName('input').length") { (res, err) in
            if let length = res as? Int {
                print("There are \(length) input fields")
                for i in 0...length-1 {
                    
                    let element = "document.getElementsByClassName('input')[\(i)]"
                    
                    self.wkWebView.evaluateJavaScript("\(element).offsetTop") { (res, err) in
                        guard let offsetTop = res as? Int else { return }
                        
                        self.wkWebView.evaluateJavaScript("\(element).offsetLeft") { (res, err) in
                            guard let offsetLeft = res as? Int else { return }
                            
                            self.wkWebView.evaluateJavaScript("\(element).offsetWidth") { (res, err) in
                                guard let offsetWidth = res as? Int else { return }
                                
                                self.wkWebView.evaluateJavaScript("\(element).offsetHeight") { (res, err) in
                                    guard let offsetHeight = res as? Int else { return }
                                    
                                    
                                    
                                    
                                    let testSwtichFrame = CGRect(x: offsetLeft, y: offsetTop, width: offsetWidth, height: offsetHeight)
                                    let testSwitch = UITextField(frame: testSwtichFrame)
                                    
                                    testSwitch.delegate = self
                                    
                                    self.wkWebView.scrollView.addSubview(testSwitch)
                                    
                                    self.wkWebView.scrollView.keyboardDismissMode = .onDrag
                                    
                                    
                                    self.wkWebView.evaluateJavaScript("\(element).placeholder") { (res, err) in
                                        guard let placeholder = res as? String else { return }
                                        testSwitch.placeholder = placeholder
                                    }
                                    
                                    self.wkWebView.evaluateJavaScript("\(element).value") { (res, err) in
                                        guard let value = res as? String else { return }
                                        testSwitch.text = value
                                    }
                                    
                                    
                                    self.wkWebView.evaluateJavaScript("window.getComputedStyle(\(element), null).getPropertyValue('text-align')") { (res, err) in
                                        guard let alignment = res as? String else { return }
                                        print("Text alignment: \(alignment)")
                                        
                                        if alignment == "center" {
                                            testSwitch.textAlignment = .center
                                        }
                                        else if alignment == "right" {
                                            testSwitch.textAlignment = .right
                                        }
                                        
                                    }
                                    
                                    testSwitch.throttle(.editingChanged, interval: 0.5) { (textField: UITextField) in
                                        guard let text = textField.text else { return }
                                        self.wkWebView.evaluateJavaScript("\(element).value = \"\(text)\"") { (res, err) in
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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

extension WebView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigation b.")
        delegate?.doneLoading(withWebView: self.wkWebView)
        replaceButtons()
        replaceInput()
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
