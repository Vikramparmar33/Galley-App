//
//  FontManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

enum FontWeight: Int {
    case thin = 100
    case extraLight = 200
    case light = 300
    case regular = 400
    case medium = 500
    case semiBold = 600
    case bold = 700
    case extraBold = 800
    case black = 900
    
    var suffix: String {
        switch self {
        case .thin: return "Thin"
        case .extraLight: return "ExtraLight"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semiBold: return "SemiBold"
        case .bold: return "Bold"
        case .extraBold: return "ExtraBold"
        case .black: return "Black"
        }
    }
}

class FontManager {
    
    static let fontName = "Exo"
    
    static func font(weight: FontWeight, size: CGFloat) -> UIFont {
        let fullName = "\(fontName)-\(weight.suffix)"
        return UIFont(name: fullName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
