//
//  UIViewExtension.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 29/11/20.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    public func fillSuperviewToSafeArea() {
        guard let superview = self.superview else { return }
        self.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(superview.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(superview.safeAreaLayoutGuide.snp.left)
                make.right.equalTo(superview.safeAreaLayoutGuide.snp.right)
                make.bottom.equalTo(superview.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(superview.snp.top)
                make.left.equalTo(superview.snp.left)
                make.right.equalTo(superview.snp.right)
                make.bottom.equalTo(superview.snp.bottom)
            }
        }
    }
}

