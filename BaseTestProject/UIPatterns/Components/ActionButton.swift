//
//  ActionButton.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 27/11/20.
//

import Foundation
import UIKit
import SnapKit

public class ActionButton: UIButton {
    override public var isEnabled: Bool {
        didSet {
            backgroundColor = self.isEnabled ? UIColor.Theme.primary : UIColor.Theme.fieldBackground
        }
    }
    
    convenience init(title: String) {
        self.init()
        configureButton(title: title)
    }
    
    public func configureButton(title: String) {
        setTitle(title.uppercased(), for: .normal)
        layer.cornerRadius = 8

        guard let titleLabel = titleLabel else { return }
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.tintColor = UIColor.Theme.textColor2
        titleLabel.font = FontStyle.f16PrimaryRegular.font
    }
}
