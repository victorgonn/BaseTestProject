//
//  BaseView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import SnapKit

protocol KeyboardIsUpProtocol {
    func resizeScroll(keyboardSize: CGFloat?)
    func keyboardIsOpen(isOpen: Bool)
}

public class BaseViewController: UIViewController {
    let loadView: LoadingView = LoadingView()
    public var hideNavigationBar: Bool = false
    var keyboardProtocol: KeyboardIsUpProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontStyle.f20PrimaryRegular.font]
        
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.view.backgroundColor = UIColor.Theme.background
        configureBackButton()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureTapAction()
    }
    
    public func configureTapAction() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func keyboardDismiss() {
        view.endEditing(true)
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
    
    @objc func keyboardShow(notification: NSNotification) {
        keyboardProtocol?.keyboardIsOpen(isOpen: true)
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        self.keyboardProtocol?.keyboardIsOpen(isOpen: false)
    }
    
    func adjustTableViewInsets(scrollView: UIScrollView) {
        let zeroContentInsets = UIEdgeInsets.zero
        scrollView.contentInset = zeroContentInsets
        scrollView.scrollIndicatorInsets = zeroContentInsets
    }
}

// MARK: Functions
extension BaseViewController {
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
