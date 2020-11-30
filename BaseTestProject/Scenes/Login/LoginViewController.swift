//
//  LoginCoordinator.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import SnapKit

protocol LoginViewControllerDelegate: class {
}

public class LoginViewController: BaseScrollViewController {
    var contentView: LoginView!
    var viewModel: LoginViewModel?
    var delegate: LoginViewControllerDelegate?

    public override func loadView() {
        super.loadView()
        contentView = LoginView()
        hideNavigationBar = true
        remakeScrollViewConstraint()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addContentView(contentView)
        self.contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height)
        NSLayoutConstraint.activate([
            self.contentViewHeight
        ])
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        contentView.emailField.baseProtocol = self
        contentView.passwordField.baseProtocol = self
        contentView.emailField.focusDelegate = self
        contentView.passwordField.focusDelegate = self
        configureLoginButton()
    }
    
    func configureLoginButton() {
        self.nextStepButton.configureButton(title: "ENTRAR")
        self.nextStepButton.isEnabled = false
        self.nextStepAction = {  [weak self] in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.showLoading(true)
        }
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentViewHeight.constant = self.scrollView.frame.size.height
    }
    
    fileprivate func remakeScrollViewConstraint() {
        scrollView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
    }
    
}

extension LoginViewController: TextFieldProtocol {
    public func didChangeValue() {
        let emailFieldIsValid = !contentView.emailField.text.isEmpty
        let passFieldIsValid = !contentView.passwordField.text.isEmpty
        self.nextStepButton.isEnabled = emailFieldIsValid && passFieldIsValid
    }
    
    public func viewClickedEvent(_ id: Int) {
        //Faz alguma coisa no CLick do TextField
    }
}
