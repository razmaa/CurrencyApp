//
//  ColorExtension.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    static let primary = AppColors.primary
    static let background = AppColors.background
    static let darkGray = AppColors.darkGray
    static let gray = AppColors.gray
    static let white = AppColors.white
}
