//
//  BaseView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import SnapKit

public class BaseViewController: UIViewController {
    let loadView: LoadingView = LoadingView()
    
    public var hideNavigationBar: Bool = false
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: WIFontStyle.f18SecondaryBold.font]
        
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.view.backgroundColor = UIColor.Theme.background
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupLeftButton(assetName: String) {
        let insets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        let imgRender = UIImage(named: assetName)?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(insets)
        
        navigationController?.navigationBar.backIndicatorImage = imgRender
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgRender
    }
    
    func configureBackButton() {
        setupLeftButton(assetName: "backButton")
    }
    
    @objc func backButtonDefaultAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureNavigationBackgorund() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    func adjustTableViewInsets(scrollView: UIScrollView) {
        let zeroContentInsets = UIEdgeInsets.zero
        scrollView.contentInset = zeroContentInsets
        scrollView.scrollIndicatorInsets = zeroContentInsets
    }
    
    // MARK: Screen Routing Stack Functions
    public func getPreviusViewControllerIndex() -> Int? {
        guard let viewControllersOnNavStack = self.navigationController?.viewControllers else {
            return nil
        }
        let controllersCount = viewControllersOnNavStack.count
        return viewControllersOnNavStack.last === self &&
            controllersCount > 1 ? (controllersCount - 2) : (controllersCount - 1)
    }
    
    public func getPreviusViewController() -> UIViewController? {
        guard let viewControllersOnNavStack = self.navigationController?.viewControllers else {
            return nil
        }
        guard let previusViewControllerIndex = self.getPreviusViewControllerIndex() else { return nil }
        return viewControllersOnNavStack[previusViewControllerIndex]
    }
    
    public func backToPreviusViewController() {
        guard let viewControllersOnNavStack = self.navigationController?.viewControllers else {
            return
        }
        guard let previusViewControllerIndex = self.getPreviusViewControllerIndex() else {
            return
        }
        self.navigationController?.popToViewController(viewControllersOnNavStack[previusViewControllerIndex],
                                                       animated: true)
    }
    
    // MARK: Screen Base Actions
    public func showLoading(_ load: Bool) {
        if load {
            self.view.addSubview(self.loadView)
            self.view.bringSubviewToFront(self.loadView)
            loadView.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.snp.top)
                make.bottom.equalTo(self.view.snp.bottom)
                make.right.equalTo(self.view.snp.right)
                make.left.equalTo(self.view.snp.left)
            }
        } else {
            self.loadView.removeFromSuperview()
            loadView.snp.removeConstraints()
        }
    }

}

