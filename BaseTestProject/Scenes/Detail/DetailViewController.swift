//
//  DetailViewController.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation
import UIKit
import Promises
import SnapKit

protocol DetailViewControllerDelegate: class {
}

public class DetailViewController: BaseViewController {
    var contentView: DetailView!
    var viewModel: DetailViewModel = DetailViewModel()
    var delegate: DetailViewControllerDelegate?

    public override func loadView() {
        super.loadView()
        contentView = DetailView()
        self.view.backgroundColor = UIColor.Theme.background
        self.view.addSubview(contentView)
        contentView.fillSuperviewToSafeArea()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getEnterpriseData()
    }
    
    public func getEnterpriseData() {
        self.showLoading(true)
        self.viewModel.getEnterpriseData().then(on: .main) { response in
            self.showLoading(false)
            self.viewModel.enterprise = response.enterprise
            self.contentView.configureView(title: response.enterprise.enterprise_name ?? "", headerColor: self.viewModel.headerColor ?? UIColor.clear, description: response.enterprise.description)
            self.navigationItem.title = response.enterprise.enterprise_name
        }.catch(on: .main) { error in
            self.showLoading(false)
            print("---> ", error)
        }
    }
}
