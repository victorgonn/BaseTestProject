//
//  BaseNavigationViewController.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 29/11/20.
//

import Foundation
import UIKit

public class BaseNavigationViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBackgorund()
    }
    
    public func configureNavigationBackgorund() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = UIColor(hexString: "#000000")

        let backArrowImage = UIImage(named: "backButton",
                                     in: Bundle(for: BaseNavigationViewController.self),
                                     compatibleWith: nil)
        self.navigationItem.leftBarButtonItem?.setBackButtonBackgroundImage(backArrowImage,
                                                                            for: .normal,
                                                                            barMetrics: .default)
    }
}
