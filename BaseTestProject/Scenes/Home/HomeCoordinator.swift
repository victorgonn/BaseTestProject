//
//  HomeCoordinator.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import UIKit

class HomeCoordinator: Coordinator {
    private var presenter: UINavigationController

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.presenter.navigationBar.backItem?.title = ""
    }
    
    func start() {
        let viewController = HomeViewController()
        viewController.delegate = self
        self.presenter.pushViewController(viewController, animated: true)
    }
    
    func popView() {
        self.presenter.popViewController(animated: false)
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    func navigateToDetail(id: Int, color: UIColor) {
        let coordinator = DetailCoordinator(presenter: self.presenter, id: id, color: color)
        coordinator.start()
    }
}
