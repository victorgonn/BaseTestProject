//
//  ApplicationCoordinator.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit

public protocol Coordinator {
    func start()
}

class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var loginCoordinator: LoginCoordinator
    private var homeCoordinator: HomeCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = BaseNavigationViewController()
        loginCoordinator = LoginCoordinator(presenter: rootViewController)
        homeCoordinator = HomeCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        loginCoordinator.start()
        //homeCoordinator.start()
        window.makeKeyAndVisible()
    }
}
