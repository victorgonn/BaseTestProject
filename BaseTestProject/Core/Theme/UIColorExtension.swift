//
//  UIColorExtension.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit

extension UIColor {
    
    public struct Theme {
        public static var primary: UIColor { return #colorLiteral(red: 0.8771181703, green: 0.1203454211, blue: 0.4101676345, alpha: 1) } // #E01E69

        public static var textColor0: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) } // #000000
        public static var textColor1: UIColor { return #colorLiteral(red: 0.3921244144, green: 0.3921751678, blue: 0.3921072483, alpha: 1) } // #666666
        public static var textColor2: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } // #FFFFFF
        
        public static var warming: UIColor { return #colorLiteral(red: 0.923535049, green: 0.3416764736, blue: 0.339322567, alpha: 1) } // #E00000
        public static var background: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } // #FFFFFF
        public static var fieldBackground: UIColor { return #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606716037, alpha: 1) } // #F5F5F5
    }
    
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a: UInt32
        let r: UInt32
        let g: UInt32
        let b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    class func hexStr(hexStr : NSString, alpha : CGFloat) -> UIColor {
        let hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.white
        }
    }
    
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
