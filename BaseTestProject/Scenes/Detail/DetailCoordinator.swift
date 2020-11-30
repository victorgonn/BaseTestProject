//
//  DetailCoordinator.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//
import UIKit

class DetailCoordinator: Coordinator {
    private var presenter: UINavigationController
    private var id: Int?
    private var color: UIColor?

    init(presenter: UINavigationController, id: Int, color: UIColor) {
        self.presenter = presenter
        self.id = id
        self.color = color
        self.presenter.navigationBar.backItem?.title = ""
    }
    
    func start() {
        let viewController = DetailViewController()
        viewController.delegate = self
        viewController.viewModel.enterpriseId = self.id ?? 0
        viewController.viewModel.headerColor = self.color
        self.presenter.pushViewController(viewController, animated: true)
    }
    
    func popView() {
        self.presenter.popViewController(animated: false)
    }
}

extension DetailCoordinator: DetailViewControllerDelegate {
}
