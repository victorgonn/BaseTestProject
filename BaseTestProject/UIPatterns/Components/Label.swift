//
//  Label.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 28/11/20.
//

import UIKit

public class Label: UILabel {
    public var fontStyle: FontStyle = .f12PrimaryRegular
    var realValue: String = ""
    var enabledUppercase: Bool = false

    public func setStyle(_ style: FontStyle, text: String = "", color: UIColor, enabledUppercase: Bool = false, numeberOfLines: Int = 0, name: String? = nil) {
        fontStyle = style
        self.numberOfLines = numeberOfLines
        font = style.font
        textColor = color
        realValue = text
        self.enabledUppercase = enabledUppercase
        self.text = self.enabledUppercase == true ? text.uppercased() : text
    }
    
    public func setText(_ text: String) {
        realValue = text
        self.text = text
    }
    
    public func setColor(_ color: UIColor) {
        textColor = color
    }

    public func setPrivacy(_ status: Bool) {
        if status {
            realValue = self.text ?? ""
            self.text = "●●●●●●●●"
        } else {
            self.text = realValue
        }
    }

}
