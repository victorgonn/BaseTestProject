//
//  LoginCoordinator.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import UIKit

class LoginCoordinator: Coordinator {
    private var presenter: UINavigationController

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.presenter.navigationBar.backItem?.title = ""
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.delegate = self
        self.presenter.pushViewController(viewController, animated: true)
    }
    
    func popView() {
        self.presenter.popViewController(animated: false)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func backNavigationMove() {
        presenter.popViewController(animated: true)
    }
    
    func navigateToHome() {
        let coordinator = HomeCoordinator(presenter: self.presenter)
        coordinator.start()
    }
}
