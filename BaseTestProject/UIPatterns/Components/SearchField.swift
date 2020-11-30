//
//  TextField.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 28/11/20.
//

import UIKit
import SnapKit


public class SearchField: FocusTextField, ConfigurableView {
    
    public lazy var searchViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Theme.fieldBackground
        return view
    }()
    
    public lazy var searchIcon: UIImageView = {
        let background = UIImageView(image: UIImage(named: "searchIcon"))
        background.contentMode = .scaleToFill
        return background
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.Theme.fieldBackground
        return textField
    }()

    public var text: String {
        get {
            return self.textField.text ?? ""
        }
        set {
            self.textField.text = newValue
        }
    }
    
    public var keyboardType: UIKeyboardType {
        get {
            return self.textField.keyboardType
        }
        set {
            self.textField.keyboardType = newValue
        }
    }

    public var delegate: UITextFieldDelegate? {
        get {
            return self.textField.delegate
        }
        set {
            self.textField.delegate = newValue
        }
    }

    public var baseProtocol: TextFieldProtocol?
    public var actionProtocol: TextFieldActionProtocol?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeView()
    }
    
    required init?(coder: NSCoder) {
        self.init()
    }
    
    fileprivate func customizeView() {
        setupView()
        isUserInteractionEnabled = true
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.backgroundColor = UIColor.Theme.fieldBackground
        
        textField.addTarget(self, action: #selector(self.onChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    public func buildViewHierarchy() {
        addSubview(searchViewContainer)
        searchViewContainer.addSubview(searchIcon)
        addSubview(textField)
    }

    public func setupConstraints() {
        
        searchViewContainer.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(48)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(searchViewContainer.snp.right)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(48)
        }
        
        searchIcon.snp.makeConstraints { (make) in
            make.top.equalTo(searchViewContainer.snp.top).offset(14)
            make.left.equalTo(searchViewContainer.snp.left).offset(14)
            make.right.equalTo(searchViewContainer.snp.right).offset(-14)
            make.bottom.equalTo(searchViewContainer.snp.bottom).offset(-14)
            make.width.equalTo(20)
        }
    }
}

// MARK: - Functions
extension SearchField {
    public func disableTextField(_ disable: Bool) {
        self.textField.isUserInteractionEnabled = disable
    }

    public func setTextFieldTag(with tag: Int) {
        textField.tag = tag
    }

    public func setTextFieldValue(with text: String) {
        textField.text = text
    }

    public func configureTextField(placeholder: String,
                                   keyboard: UIKeyboardType = .default,
                                   isEnabled: Bool = true,
                                   id: Int = 0) {
        self.backgroundColor = .clear
        
        textField.tag = 0
        textField.font = FontStyle.f16PrimaryRegular.font
        textField.textColor = UIColor.Theme.textColor0
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.isEnabled = isEnabled
        textField.placeholder = placeholder
        textField.tintColor = UIColor.Theme.primary
        setupSearchIcon()
    }

    public func activeTextField(_ isEnabled: Bool) {
        textField.isEnabled = isEnabled
    }

    public func setupSearchIcon() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconClick))
        searchIcon.isUserInteractionEnabled = true
        searchIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func iconClick() {
        _ = textField.becomeFirstResponder()
    }

    @objc func editingDidBegin() {
        baseProtocol?.viewClickedEvent(textField.tag)
        self.focusDelegate?.onFocusTextField(view: self)
    }

    @objc func editingDidEnd() {
        self.focusDelegate?.onRemoveFocus(view: self)
    }
    
    @objc func onChange() {
        baseProtocol?.didChangeValue()
    }

    public func setFocus() {
        _ = becomeFirstResponder()
    }
}
