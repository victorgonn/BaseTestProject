//
//  LoginCoordinator.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import Promises
import SnapKit

protocol HomeViewControllerDelegate: class {
    func navigateToDetail(id: Int, color: UIColor)
}

public class HomeViewController: BaseViewController {
    var headerView: HomeView!
    var tableView: UITableView!
    var viewModel: HomeViewModel = HomeViewModel()
    var delegate: HomeViewControllerDelegate?
    var defaultCellId: String = "DefaultCellId"

    public override func loadView() {
        super.loadView()
        self.hideNavigationBar = true
        headerView = HomeView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        keyboardProtocol = self
        
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        buildViewHierarchy()
        setupConstraints()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doSearch()
    }
    
    public func doSearch() {
        self.headerView.rebuildHeaderConstraints(headerType: .thin)
        self.viewModel.searched = true
        self.viewModel.getEnterprises().then(on: .main) { response in
            self.showLoading(false)
            self.viewModel.filtredData = response.enterprises
            self.tableView.reloadData()
        }.catch(on: .main) { error in
            self.showLoading(false)
        }
    }
    
    public func buildViewHierarchy() {
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
    }
    
    public func setupConstraints() {
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

extension HomeViewController: KeyboardIsUpProtocol {
    func resizeScroll(keyboardSize: CGFloat?) {
        //resizeScroll
    }
    
    func keyboardIsOpen(isOpen: Bool) {
        if !self.viewModel.searched {
            self.headerView.rebuildHeaderConstraints(headerType: isOpen == true ? .thin : .fat)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.filtredData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath)
            cell.backgroundColor = UIColor.Theme.background
            cell.textLabel?.text = "\(self.viewModel.filtredData.count) resultados encontrados"
            cell.textLabel?.font = FontStyle.f14PrimaryRegular.font
            cell.textLabel?.textColor = UIColor.Theme.textColor1
            cell.textLabel?.textAlignment = .left
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath)
            let item = self.viewModel.filtredData[indexPath.section]
            cell.backgroundColor = UIColor.random()
            cell.textLabel?.text = item.enterprise_name?.uppercased() ?? ""
            cell.textLabel?.font = FontStyle.f18PrimaryBold.font
            cell.textLabel?.textColor = UIColor.Theme.textColor2
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 120
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath)
        let item = self.viewModel.filtredData[indexPath.section]
        self.delegate?.navigateToDetail(id: item.id, color: cell.backgroundColor ?? UIColor.clear)
    }
}
