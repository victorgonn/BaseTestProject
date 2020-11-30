//
//  TextField.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 28/11/20.
//

import UIKit
import SnapKit

public protocol TextFieldProtocol {
    func didChangeValue()
    func viewClickedEvent(_ id: Int)
}

public protocol TextFieldActionProtocol {
    func passwordClickedEvent()
    func addClickAction()
}

public class TextField: FocusTextField, ConfigurableView {
    public lazy var titleLabel: Label = {
        let titleLabel = Label()
        return titleLabel
    }()
    public lazy var helpLabel: Label = {
        let textLabel = Label()
        return textLabel
    }()
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.Theme.fieldBackground
        return textField
    }()

    public var maxLenght: Int?
    public var hint: String?
    public var isTextHidden: Bool = false

    public var button = UIButton(type: .custom)
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
    public var isSecureTextEntry: Bool {
        get {
            return self.textField.isSecureTextEntry
        }
        set {
            self.textField.isSecureTextEntry = newValue
            if self.textField.isFirstResponder {
                _ = becomeFirstResponder()
            }
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
    public var defaultButtonText: String?

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
        
        textField.addTarget(self, action: #selector(onChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    public func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(helpLabel)
    }

    public func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left).offset(4)
            make.right.equalTo(snp.right).offset(-4)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(48)
        }

        helpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.left.equalTo(snp.left).offset(4)
            make.right.equalTo(snp.right).offset(-4)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    public override func becomeFirstResponder() -> Bool {
        let success = self.textField.becomeFirstResponder()
        if isSecureTextEntry, let text = self.textField.text {
            self.textField.text?.removeAll()
            self.textField.insertText(text)
        }
        return success
    }
}

// MARK: - Functions
extension TextField {
    public func disableTextField(_ disable: Bool) {
        self.textField.isUserInteractionEnabled = disable
    }

    public func setTextFieldTag(with tag: Int) {
        textField.tag = tag
    }

    public func setTextFieldValue(with text: String) {
        textField.text = text
    }

    public func configureTextField(text: String,
                                   hint: String?,
                                   isSecure: Bool = false,
                                   keyboard: UIKeyboardType = .default,
                                   isEnabled: Bool = true,
                                   id: Int = 0,
                                   maxLeght: Int?) {
        self.backgroundColor = .clear
        
        textField.tag = 0
        titleLabel.font = FontStyle.f14PrimaryRegular.font
        titleLabel.setColor(UIColor.Theme.textColor1)
        titleLabel.text = text
        helpLabel.font = FontStyle.f12PrimaryRegular.font
        helpLabel.numberOfLines = 0

        textField.font = FontStyle.f16PrimaryRegular.font
        textField.textColor = UIColor.Theme.textColor0
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.isSecureTextEntry = isSecure
        textField.isEnabled = isEnabled
        textField.tintColor = UIColor.Theme.primary

        if let hint =  hint {
            displayHint(hint)
        }
        
        if let maxSize = maxLeght {
            self.maxLenght = maxSize
            self.textField.delegate = self
        }
    }

    public func activeTextField(_ isEnabled: Bool) {
        textField.isEnabled = isEnabled
    }

    public func setPasswordLayout() {
        self.isSecureTextEntry = true
        setupPasswordButton(iconName: "visibilityOn")
    }

    public func setLoginPasswordButtonLayout(buttonText: String) {
        actionProtocol?.passwordClickedEvent()
        self.defaultButtonText = buttonText
        button.addTarget(self, action: #selector(self.rightButtonAction), for: .touchUpInside)
    }
    
    public func updateLoginPasswordButtonLayout() {
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(3), height: CGFloat(15))
        button.contentMode = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let iconName = self.isSecureTextEntry ? "visibilityOn" : "visibilityOff"
        self.setButtonImage(iconName: iconName)
        textField.rightView = button
        textField.rightViewMode = .always
    }

    @objc private func rightButtonAction() {
        if !self.text.isEmpty {
            self.passwordEyeAction()
        } else {
            actionProtocol?.addClickAction()
        }
    }

    func setupPasswordButton(iconName: String) {
        self.setButtonImage(iconName: iconName)
        button.addTarget(self, action: #selector(self.passwordEyeAction), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }

    @objc private func passwordEyeAction() {
        self.isSecureTextEntry = !self.isSecureTextEntry
        let iconName = self.isSecureTextEntry ? "visibilityOn" : "visibilityOff"
        self.setButtonImage(iconName: iconName)
    }

    private func setButtonImage(iconName: String) {
        let buttonImage = UIImage(named: iconName)?.withTintColor(UIColor.Theme.textColor1)
        
        if let img = buttonImage?.resizeWithScaleAspectFitMode(to: 22) {
            button.setImage(img, for: .normal)
        } else {
            button.setImage(buttonImage, for: .normal)
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(15), height: CGFloat(15))
    }

    @objc public func rightAction() {
        actionProtocol?.addClickAction()
    }

    public func setButton(with image: String) {
        let i = UIImage(named: image, in: Bundle(for: TextField.self), compatibleWith: nil)
        button.setImage(i, for: .normal)
    }

    func resetHint() {
        helpLabel.isHidden = true
        helpLabel.setColor(UIColor.Theme.textColor1)
        helpLabel.textAlignment = .left
        helpLabel.text = ""
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
    }
    
    func displayError(_ error: String) {
        helpLabel.isHidden = false
        helpLabel.setColor(UIColor.Theme.warming)
        helpLabel.textAlignment = .right
        helpLabel.text = error
        
        textField.layer.borderColor = UIColor.Theme.warming.cgColor
        textField.layer.borderWidth = 1.0
    }

    func displayHint(_ hint: String) {
        helpLabel.isHidden = false
        helpLabel.setColor(UIColor.Theme.textColor1)
        helpLabel.textAlignment = .right
        helpLabel.text = hint
    }

    @objc func editingDidBegin() {
        baseProtocol?.viewClickedEvent(textField.tag)
        if let hint = self.hint {
            displayHint(hint)
        } else {
            helpLabel.isHidden = false
            helpLabel.text = ""
        }
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
    
    public func isValidLength(textSize: Int) -> Bool {
        if let maxSize = self.maxLenght {
            return textSize <= maxSize
        }
        return true
    }
}

extension TextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
             let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                 return false
         }

        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return isValidLength(textSize: count)
    }
}
