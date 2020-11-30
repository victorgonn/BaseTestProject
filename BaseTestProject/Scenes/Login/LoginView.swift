//
//  LoginView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import UIKit
import SnapKit

public enum HeaderType {
    case thin
    case fat
}

class LoginView: BaseView {
    var buttonAction: (() -> Void)?
    let headerBackGroundImageView: UIImageView = {
        let background = UIImageView(image: UIImage(named: "loginHeaderBackground"))
        background.contentMode = .scaleToFill
        return background
    }()
    
    let headerLogoImage: UIImageView = {
        let background = UIImageView(image: UIImage(named: "logoHome"))
        background.contentMode = .scaleToFill
        return background
    }()
    
    let headerTailBackGroundImageView: UIImageView = {
        let background = UIImageView(image: UIImage(named: "loginTailBackground"))
        background.contentMode = .scaleToFill
        return background
    }()
    
    let titleLabel: Label = {
        let label = Label()
        label.setStyle(.f20PrimaryRegular, text: "Seja bem vindo ao empresas!", color: UIColor.Theme.background, enabledUppercase: false, numeberOfLines: 0, name: nil)
        return label
    }()
        
    let emailField = TextField()
    let passwordField = TextField()
    let actionButton = ActionButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        emailField.configureTextField(text: "Email", hint: nil, maxLeght: nil)
        emailField.setTextFieldTag(with: 1)
        emailField.textField.text = "testeapple@ioasys.com.br"
        passwordField.configureTextField(text: "Senha", hint: nil, maxLeght: nil)
        passwordField.setPasswordLayout()
        passwordField.setTextFieldTag(with: 2)
        passwordField.textField.text = "12341234"
        
        actionButton.configureButton(title: "ENTRAR")
        actionButton.isEnabled = true
        actionButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        buildViewHierarchy()
        setupConstraints()
    }
    
    public func buildViewHierarchy() {
        addSubview(headerBackGroundImageView)
        headerBackGroundImageView.addSubview(headerLogoImage)
        headerBackGroundImageView.addSubview(titleLabel)
        addSubview(headerTailBackGroundImageView)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(actionButton)
    }
    
    public func setupConstraints() {
        headerBackGroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(200)
        }
        
        headerTailBackGroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(headerBackGroundImageView.snp.bottom)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(55)
        }
        
        headerLogoImage.snp.makeConstraints { (make) in
            make.top.equalTo(headerBackGroundImageView.snp.top).offset(99.3)
            make.centerX.equalTo(headerBackGroundImageView.snp.centerX)
            make.height.equalTo(32)
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLogoImage.snp.bottom).offset(16.5)
            make.left.equalTo(snp.left).offset(52)
            make.right.equalTo(snp.right).offset(-52)
        }
        
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(headerTailBackGroundImageView.snp.bottom).offset(24)
            make.left.equalTo(snp.left).offset(16)
            make.right.equalTo(snp.right).offset(-16)
        }

        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.left.equalTo(snp.left).offset(16)
            make.right.equalTo(snp.right).offset(-16)
        }
        
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(40)
            make.left.equalTo(snp.left).offset(31)
            make.right.equalTo(snp.right).offset(-31)
            make.height.equalTo(48)
        }
    }
    
    public func rebuildHeaderConstraints(headerType: HeaderType) {
        switch headerType {
        case .thin:
            headerBackGroundImageView.image = UIImage(named: "loginHeaderBackgroundThin")
            headerBackGroundImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(snp.top)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.height.equalTo(100)
            }
            
            headerTailBackGroundImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(headerBackGroundImageView.snp.bottom)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.height.equalTo(55)
            }
            
            headerLogoImage.snp.remakeConstraints { (make) in
                make.bottom.equalTo(headerBackGroundImageView.snp.bottom)
                make.centerX.equalTo(headerBackGroundImageView.snp.centerX)
                make.height.equalTo(32)
                make.width.equalTo(40)
            }
            
            titleLabel.snp.removeConstraints()
            titleLabel.isHidden = true
        default:
            headerBackGroundImageView.image = UIImage(named: "loginHeaderBackground")
            headerBackGroundImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(snp.top)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.height.equalTo(200)
            }
            
            headerTailBackGroundImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(headerBackGroundImageView.snp.bottom)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.height.equalTo(55)
            }
            
            headerLogoImage.snp.remakeConstraints { (make) in
                make.top.equalTo(headerBackGroundImageView.snp.top).offset(99.3)
                make.centerX.equalTo(headerBackGroundImageView.snp.centerX)
                make.height.equalTo(32)
                make.width.equalTo(40)
            }
            
            titleLabel.isHidden = false
            titleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(headerLogoImage.snp.bottom).offset(16.5)
                make.left.equalTo(snp.left).offset(52)
                make.right.equalTo(snp.right).offset(-52)
            }
        }
    }
    
    @objc
    fileprivate func buttonClick() {
        self.buttonAction?()
    }
}
