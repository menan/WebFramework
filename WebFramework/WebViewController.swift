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

    var webView: WKWebView!
    let userContentController = WKUserContentController()
    
    var path = ""
    
    convenience init() {
        self.init(with: WKWebView())
    }
    
    init(with webView: WKWebView, and path: String = "") {
        self.webView = webView
        self.path = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
        userContentController.add(self, name: "pushToNext")
        userContentController.add(self, name: "dismissView")
        userContentController.add(self, name: "presentView")
        userContentController.add(self, name: "setNavTitle")
        userContentController.add(self, name: "toggleNavBar")
        userContentController.add(self, name: "setNavBarBackground")
        userContentController.add(self, name: "setTabBarTint")
        userContentController.add(self, name: "setTitleFont")
        userContentController.add(self, name: "toggleScrolling")
        
        
        setNavTitle("WebFramework")
        
        self.view = self.webView
        
        
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
        
        
        webView.scrollView.isScrollEnabled = false
        
        print("Loading: index.html#!\(path)")
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func pushToNext(_ message: Any) {
        let viewController = WebViewController(with: webView, and: message as? String ?? "")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func presentView(_ message:  Any) {
        
        let viewController = UINavigationController(rootViewController: WebViewController(with: webView))
        
        self.present(viewController, animated: true) {
            print("Its done.")
        }
    }
    @objc func dismissView(_ message:  Any) {
        self.dismiss(animated: true) {
            print("Its done.")
        }
    }
    
    @objc func setNavTitle(_ message: Any) {
        
        var vc: UIViewController!
        if parent is TabBarViewController {
            vc = parent
        }
        else {
            vc = self
        }
        vc.title = message as? String
        
//        vc.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    @objc func setTitleFont(_ message: Any) {
        
        if let fontData = message as? [String: Any],
            let fontName = fontData["fontName"] as? String,
            let fontSize = fontData["fontSize"] as? Float,
            let bundle = Bundle(identifier: "com.owl-home-inc.WebFramework"),
            let url = bundle.url(forResource:fontName, withExtension: "ttf") {
            do {
                try UIFont.register(from: url)
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: fontName, size: CGFloat(fontSize))!]
            } catch {
                print(error)
            }
        }
        
    }
    
    @objc func setTitleColor(_ message: Any) {
        if let color = message as? String {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: color)]
        }
    }
    
    
    @objc func toggleNavBar(_ message: Any) {
        guard let navController = self.navigationController else { return }
        
        if navController.isNavigationBarHidden {
            navController.setNavigationBarHidden(false, animated: true)
        }
        else {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    @objc func toggleScrolling(_ message: Any) {
        webView.scrollView.isScrollEnabled = !webView.scrollView.isScrollEnabled
    }
    
    @objc func toggleSidebar(_ message: Any) {
        //show or hide left bar button item
        var vc: UIViewController!
        if parent is TabBarViewController {
            vc = parent
        }
        else {
            vc = self
        }
        
        if vc.navigationItem.leftBarButtonItem == nil {
            let menu = UIBarButtonItem(image: UIImage(named: "menu-thin"), style: .plain, target: self, action: #selector(sidebarToggled))
            vc.navigationItem.leftBarButtonItem  = menu
        }
        else {
            vc.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func setNavBarBackground(_ message: Any) {
//        if let imageName = message as? String {
//            if let image = UIImage(named: "Image-1") {
//                self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//            }
//            else {
//                print("Image not found: \(message)")
//            }
//        }
//        else {
//            print("Invalid image path.")
//        }
//
//        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let userDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//        let paths             = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
//        if let dirPath        = paths.first
//        {
//            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Image-1.png")
//            if let image    = UIImage(contentsOfFile: imageURL.path) {
//                self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//            }
//            else {
//                print("Image not found.")
//            }
//            // Do whatever you want with the image
//        }
        
        if let imagePath = Bundle.main.path(forResource:"Image-1", ofType: "png", inDirectory: "Images") {
            print("Image URL: \(imagePath)")
            if let image = UIImage(contentsOfFile: imagePath) {
                print("Image: \(image)")
                self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            }
            else {
                print("Can't open image at: \(imagePath).")
            }
        }
        else {
            print("Image not found.")
        }
    }
    
    @objc func setTabBarTint(_ message: Any) {
        if let color = message as? String {
            self.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: color)
        }
    }
    
    @objc func sidebarToggled(_ message: Any) {
        
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Executing: \(message.name)")
        switch message.name {
        case "pushToNext":
            pushToNext(message.body)
            break
        case "dismissView":
            dismissView(message.body)
            break
        case "presentView":
            presentView(message.body)
            break
        case "setNavTitle":
            setNavTitle(message.body)
            break
        case "toggleNavBar":
            toggleNavBar(message.body)
            break
        case "setNavBarBackground":
            setNavBarBackground(message.body)
            break
        case "setTabBarTint":
            setTabBarTint(message.body)
            break
        case "setTitleFont":
            setTitleFont(message.body)
            break
        case "toggleScrolling":
            toggleScrolling(message.body)
            break
        default:
            pushToNext(message.body)
        }
    }
}


public extension UIFont {
    public static func register(from url: URL) throws {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            return
//            throw SVError.internal("Could not create font data provider for \(url).")
        }
        guard let font = CGFont(fontDataProvider) else { return }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            throw error!.takeUnretainedValue()
        }
    }
}


