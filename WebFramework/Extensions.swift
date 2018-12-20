//
//  Extensions.swift
//  WebFramework
//
//  Created by Vadivelpillai, menan on 11/16/18.
//  Copyright © 2018 Owl Home Inc. All rights reserved.
//

import UIKit

extension UIColor {
    static func color(from hex: String) -> UIColor {
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
    
    static func color(withRGBString: String) -> UIColor {
        
        var colorString = withRGBString.replacingOccurrences(of: "rgb(", with: "")
        colorString = colorString.replacingOccurrences(of: ")", with: "")
        
        let colorsArray = colorString.split(separator: ",")
        
        let red = Int(colorsArray[0]) ?? 0
        let green = Int(colorsArray[1]) ?? 0
        let blue = Int(colorsArray[2]) ?? 0
        let alpha = colorsArray.count == 4 ? Int(colorsArray[0]) ?? 1 : 1
        
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(alpha))
    }
}


extension UIFont {
    static func register(from url: URL) throws {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            return print("Could not create font data provider for \(url).")
        }
        guard let font = CGFont(fontDataProvider) else { return }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            throw error!.takeUnretainedValue()
        }
    }
}

extension UIImage {
    
    static func imageFrom(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
}
