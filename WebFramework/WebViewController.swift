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
        if let image = UIImage(named: image) {
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        }
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
//    @objc func setNavBarBackground(_ message: Any) {
//        //        if let imageName = message as? String {
//        //            if let image = UIImage(named: "Image-1") {
//        //                self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//        //            }
//        //            else {
//        //                print("Image not found: \(message)")
//        //            }
//        //        }
//        //        else {
//        //            print("Invalid image path.")
//        //        }
//        //
//        //        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        //        let userDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//        //        let paths             = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
//        //        if let dirPath        = paths.first
//        //        {
//        //            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Image-1.png")
//        //            if let image    = UIImage(contentsOfFile: imageURL.path) {
//        //                self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//        //            }
//        //            else {
//        //                print("Image not found.")
//        //            }
//        //            // Do whatever you want with the image
//        //        }
//
//        if let imagePath = Bundle.main.path(forResource:"Image-1", ofType: "png", inDirectory: "Images") {
//            print("Image URL: \(imagePath)")
//            if let image = UIImage(contentsOfFile: imagePath) {
//                print("Image: \(image)")
//                delegate.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//            }
//            else {
//                print("Can't open image at: \(imagePath).")
//            }
//        }
//        else {
//            print("Image not found.")
//        }
//    }
//
//
}

