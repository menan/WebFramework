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
    
    var path = ""
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(path: String?) {
        self.path = path ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
    }
    
//    override func viewWillLayoutSubviews() {
//
//        WebView.shared.delegate = self
//        self.view = WebView.shared.wkWebView
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.view = WebView.shared.wkWebView
        }
        
        WebView.shared.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.view == nil { return }
        
        
        DispatchQueue.main.async { [unowned self] in
            if let image = self.screenshot() {
                let imageView = UIImageView(frame: self.view.frame)
                imageView.image = image
                self.view = imageView
                return
            }
            self.view = nil
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
    func pushViewController(path: String?) {
        let viewController = WebViewController(path: path)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func presentViewController(path: String?) {
        let viewController = WebViewController(path: path)
        self.navigationController?.present(viewController, animated: true, completion: {
            self.view = nil
            viewController.view = WebView.shared.wkWebView
            print("its Done")
        })
    }
    func dismissViewController() {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor.white
        self.view = view
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
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
        self.view = withWebView
    }
    
    
//    @objc func pushToNext(_ message: Any) {
//        let viewController = WebViewController(with: self, and: message as? String ?? "")
//
//        delegate.navigationController?.pushViewController(viewController, animated: true)
//    }
//    @objc func presentView(_ message:  Any) {
//
//        let viewController = UINavigationController(rootViewController: WebViewController(with: self))
//
//        delegate.present(viewController, animated: true) {
//            print("Its done.")
//        }
//    }
//    @objc func dismissView(_ message:  Any) {
//        delegate.dismiss(animated: true) {
//            print("Its done.")
//        }
//    }
//
//    @objc func setNavTitle(_ message: Any) {
//
//        var vc: UIViewController!
//        if delegate.parent is TabBarViewController {
//            vc = delegate.parent
//        }
//        else {
//            vc = delegate
//        }
//        vc.title = message as? String
//
//        //        vc.navigationController?.navigationBar.prefersLargeTitles = true
//
//    }
//
//    @objc func setTitleFont(_ message: Any) {
//
//        if let fontData = message as? [String: Any],
//            let fontName = fontData["fontName"] as? String,
//            let fontSize = fontData["fontSize"] as? Float,
//            let bundle = Bundle(identifier: "com.owl-home-inc.WebFramework"),
//            let url = bundle.url(forResource:fontName, withExtension: "ttf") {
//            do {
//                try UIFont.register(from: url)
//                delegate.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: fontName, size: CGFloat(fontSize))!]
//            } catch {
//                print(error)
//            }
//        }
//
//    }
//
//    @objc func setTitleColor(_ message: Any) {
//        if let color = message as? String {
//            delegate.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: color)]
//        }
//    }
//
//
//    @objc func toggleNavBar(_ message: Any) {
//        guard let navController = delegate.navigationController else { return }
//
//        if navController.isNavigationBarHidden {
//            navController.setNavigationBarHidden(false, animated: true)
//        }
//        else {
//            navController.setNavigationBarHidden(true, animated: true)
//        }
//    }
//
//
//    @objc func toggleScrolling(_ message: Any) {
//        wkWebView.scrollView.isScrollEnabled = !wkWebView.scrollView.isScrollEnabled
//    }
//
//    @objc func toggleSidebar(_ message: Any) {
//        //show or hide left bar button item
//        var vc: UIViewController!
//        if delegate.parent is TabBarViewController {
//            vc = delegate.parent
//        }
//        else {
//            vc = delegate
//        }
//
//        if vc.navigationItem.leftBarButtonItem == nil {
//            let menu = UIBarButtonItem(image: UIImage(named: "menu-thin"), style: .plain, target: self, action: #selector(sidebarToggled))
//            vc.navigationItem.leftBarButtonItem  = menu
//        }
//        else {
//            vc.navigationItem.leftBarButtonItem = nil
//        }
//    }
//
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
//    @objc func setTabBarTint(_ message: Any) {
//        if let color = message as? String {
//            delegate.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: color)
//        }
//    }
//
//    @objc func sidebarToggled(_ message: Any) {
//
//
//    }
    
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


