//
//  ConfigurableView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit

public protocol ConfigurableView: UIView {
    func setupView()
    func buildViewHierarchy()
    func setupConstraints()
}

public extension ConfigurableView {
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        buildViewHierarchy()
        setupConstraints()
    }
}
