//
//  UIFontStyle.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 29/11/20.
//

import Foundation
import UIKit

public struct FontWeight {
    public static let primaryRegular: String = "RubikRoman-Regular"
    public static let primaryBold: String = "RubikRoman-Bold"
}

public enum FontStyle {
     case f12PrimaryRegular
     case f12PrimaryBold
     case f14PrimaryRegular
     case f14PrimaryBold
     case f16PrimaryRegular
     case f16PrimaryBold
     case f18PrimaryRegular
     case f18PrimaryBold
     case f20PrimaryRegular
     case f20PrimaryBold

     public var weight: String {
        switch self {
        case .f12PrimaryRegular, .f14PrimaryRegular, .f16PrimaryRegular, .f18PrimaryRegular, .f20PrimaryRegular:
            return FontWeight.primaryRegular
        case .f12PrimaryBold, .f14PrimaryBold, .f16PrimaryBold, .f18PrimaryBold, .f20PrimaryBold:
            return FontWeight.primaryBold
        }
    }

    public var size: CGFloat {
        let additionalSize: CGFloat = UIScreen.main.bounds.width > 400 ? 0 : 0.1
        var size: CGFloat = 0
        
        switch self {
        case .f12PrimaryRegular, .f12PrimaryBold:
            size = 12
        case .f14PrimaryRegular, .f14PrimaryBold:
            size = 14
        case .f16PrimaryRegular, .f16PrimaryBold:
            size = 16
        case .f18PrimaryRegular, .f18PrimaryBold:
            size = 18
        case .f20PrimaryRegular, .f20PrimaryBold:
            size = 20
        }
        
        return size + additionalSize
    }
    
    public var font: UIFont {
        return UIFont(name: weight, size: size) ?? UIFont.systemFont(ofSize: 12)
    }
}
