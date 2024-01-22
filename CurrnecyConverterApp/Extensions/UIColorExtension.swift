//
//  UIColorExtension.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 23.01.24.
//


import UIKit

struct AppColors {
    static let primary = UIColor(hex: "#552CAD")
    static let background = UIColor(hex: "#0A061A")
    static let darkGray = UIColor(hex: "#231F31")
    static let gray = UIColor(hex: "#83818A")
    static let white = UIColor(hex: "#F3F1F7")
}

extension UIColor {
    convenience init(hex: String) {
         var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
         hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
 
         var rgb: UInt64 = 0
         Scanner(string: hexSanitized).scanHexInt64(&rgb)
 
         let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
         let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
         let blue = CGFloat(rgb & 0x0000FF) / 255.0
 
         self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static let primary = AppColors.primary
    static let background = AppColors.background
    static let darkGray = AppColors.darkGray
    static let gray = AppColors.gray
    static let white = AppColors.white
}
