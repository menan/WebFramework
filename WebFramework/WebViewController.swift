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
    
    var path = "#/!"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(path: String?) {
        
        self.path = path == nil ? "#/!" : "#!\(path!)"
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        print("\(#function)")
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        WebView.shared.delegate = self
        for subView in view.subviews { subView.removeFromSuperview() }
        view.addSubview(WebView.shared.wkWebView)
        
        if WebView.shared.wkWebView.isLoading { return }
        
        
        
        
        WebView.shared.wkWebView.evaluateJavaScript("window.location = \"\(path)\"") {(value, err) in
            print("Javascript evaluated ")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let image = self.screenshot() {
            let imageView = UIImageView(frame: self.view.frame)
            imageView.image = image
            self.view.addSubview(imageView)
            return
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        return image
    }
    
}


extension WebViewController: UIViewControllerDelegate {
    func setNavBarBackground(image: String) {
        let image = UIImage.imageFrom(imageString: image)
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func pushViewController(path: String?) {
        let viewController = WebViewController(path: path)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func presentViewController(path: String?) {
        print("\(#function)")
        let viewController = WebViewController(path: path)
        self.navigationController?.present(viewController, animated: true, completion: {
            print("its Done")
        })
    }
    func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    func setNavigationBar(title: String?) {
        var vc: UIViewController!
        if self.parent is TabBarViewController {
            vc = self.parent
        }
        else {
            vc = self
        }
        vc.title = title
    }
    
    func doneLoading(withWebView: WKWebView) {
        print("WebView done navigation")
        
    }
    
    func setScrolling(enabled: Bool) {
        WebView.shared.wkWebView.scrollView.isScrollEnabled = enabled
    }
    
    @objc func setTabBarTint(color: UIColor) {
        self.tabBarController?.tabBar.tintColor = color
    }
    
    
    func setTitleFont(with data: [String: Any]?) {
        if let fontData = data,
            let fontName = fontData["fontName"] as? String,
            let fontSize = fontData["fontSize"] as? Float,
            let fontColor = fontData["fontColor"] as? String,
            let bundle = Bundle(identifier: "com.owl-home-inc.WebFramework"),
            let url = bundle.url(forResource:fontName, withExtension: "ttf") {
            do {
                try UIFont.register(from: url)
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.font: UIFont(name: fontName, size: CGFloat(fontSize))!,
                    NSAttributedString.Key.foregroundColor: UIColor.color(from: fontColor)
                ]
            } catch {
                print(error)
            }
        }
    }
    
    func showNavBar() {
        guard let navController = self.navigationController else { return }
        navController.setNavigationBarHidden(false, animated: true)
    }
    func hideNavBar() {
        guard let navController = self.navigationController else { return }
        navController.setNavigationBarHidden(true, animated: true)
    }
}

