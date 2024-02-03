//
//  ColorExtension.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 03.02.24.
//

import SwiftUI

struct AppColorsSwiftUI {
    static let primary = Color(hex: "#552CAD")
    static let background = Color(hex: "#0A061A")
    static let darkGray = Color(hex: "#231F31")
    static let gray = Color(hex: "#83818A")
    static let white = Color(hex: "#F3F1F7")
}

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
    
    static let primary = AppColorsSwiftUI.primary
    static let background = AppColorsSwiftUI.background
    static let darkGray = AppColorsSwiftUI.darkGray
    static let gray = AppColorsSwiftUI.gray
    static let white = AppColorsSwiftUI.white
}
