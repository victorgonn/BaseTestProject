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

protocol LoginViewControllerDelegate: class {
    func navigateToHome()
}

public class LoginViewController: BaseScrollViewController {
    var contentView: LoginView!
    var viewModel: LoginViewModel = LoginViewModel()
    var delegate: LoginViewControllerDelegate?

    public override func loadView() {
        ignoreTopSafeAreaMargin = true
        super.loadView()
        contentView = LoginView()
        hideNavigationBar = true
        setupConstraints()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardProtocol = self
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
        contentView.buttonAction = {
            self.resetTextFields()
            self.view.endEditing(true)
            self.showLoading(true)
            self.viewModel.doLogin().then(on: .main) { _ in
                self.showLoading(false)
                self.delegate?.navigateToHome()
            }.catch(on: .main) { error in
                self.showLoading(false)
                self.handleError()
            }
        }
    }
        
    fileprivate func resetTextFields() {
        self.contentView.emailField.resetHint()
        self.contentView.passwordField.resetHint()
    }
    
    fileprivate func handleError() {
        self.contentView.emailField.displayError("")
        self.contentView.passwordField.displayError("Credenciais incorretas")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentViewHeight.constant = self.scrollView.frame.size.height + self.gradientView.frame.size.height
    }
}

extension LoginViewController: TextFieldProtocol {
    public func didChangeValue() {
        let emailFieldIsValid = !contentView.emailField.text.isEmpty
        let passFieldIsValid = !contentView.passwordField.text.isEmpty
        self.viewModel.email = contentView.emailField.text
        self.viewModel.password = contentView.passwordField.text
        self.contentView.actionButton.isEnabled = emailFieldIsValid && passFieldIsValid
    }
    
    public func viewClickedEvent(_ id: Int) {
        //Faz alguma coisa no CLick do TextField
    }
}

extension LoginViewController: KeyboardIsUpProtocol {
    func resizeScroll(keyboardSize: CGFloat?) {
        //resizeScroll
    }
    
    func keyboardIsOpen(isOpen: Bool) {
        self.contentView.rebuildHeaderConstraints(headerType: isOpen == true ? .thin : .fat)
    }
}
