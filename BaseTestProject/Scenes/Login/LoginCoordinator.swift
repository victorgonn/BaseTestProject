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
    
//    func navigateToRecoveryPass() {
//        let coordinator = PasswordRevoceryStepsViewCoordinator(presenter: self.presenter, type: nil)
//        coordinator.start()
//    }
//
//    func navigateToUserChangePass() {
//        let coordinator = PasswordRecoveryChangeCoordinator(presenter: self.presenter, operationType: .userOperation)
//       coordinator.start()
//    }
//
//    func navigateToBlockedPass() {
//        let coordinator = PasswordRecoveryWallCoordinator(presenter: self.presenter, type: .transactions)
//       coordinator.start()
//    }
}
