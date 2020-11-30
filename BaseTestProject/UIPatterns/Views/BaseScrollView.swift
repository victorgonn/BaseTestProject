//
//  BaseScrollView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import SnapKit

public protocol TextFieldFocusProtocol {
    func onFocusTextField(view: FocusTextField)
    func onRemoveFocus(view: FocusTextField)
}

open class FocusTextField: UIView {
    public var focusDelegate: TextFieldFocusProtocol?
}

public class BaseScrollViewController: BaseViewController, TextFieldFocusProtocol {
    public var scrollView: UIScrollView!
    public var gradientView: GradientView!
    public var nextStepButton: ActionButton!
    public var nextStepAction: (() -> Void)?
    public var showKeyboardAction: ((NSNotification) -> Void)?
    public var hideKeyboardAction: ((NSNotification) -> Void)?
    
    public var contentViewHeight: NSLayoutConstraint!
    public var buttonBottomConstraint: NSLayoutConstraint!
    public var lastOffset: CGPoint!
    public var focusedField: FocusTextField?
    public var keyboardHeight: CGFloat!
    public var distanceBottomCalculus: ((FocusTextField) -> CGFloat)!
    
    var ignoreTopSafeAreaMargin: Bool = false
    
    public func onFocusTextField(view: FocusTextField) {
        self.focusedField = view
        self.lastOffset = self.scrollView.contentOffset
    }
    
    public func onRemoveFocus(view: FocusTextField) {
        self.focusedField = nil
    }
    
    // MARK: Life Cycle
    public override func loadView() {
        super.loadView()
        buildViewHierarchy()
        setupConstraints()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        self.configureKeyboardShowAction()
//        self.configureKeyboardHideAction()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        automaticallyAdjustsScrollViewInsets = false
    }
      
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: Build Functions
    public func buildViewHierarchy() {
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.gradientView = GradientView()
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextStepButton = ActionButton()
        self.nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextStepButton.addTarget(self, action: #selector(nextStepButtonAction), for: .touchDown)
        self.gradientView.addSubview(self.nextStepButton)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.gradientView)
    }
    
    public func setupConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.ignoreTopSafeAreaMargin == true ? self.view.snp.top : self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    
        nextStepButton.snp.makeConstraints { (make) in
            make.top.equalTo(gradientView.snp.top).offset(10)
            make.left.equalTo(gradientView.snp.left).offset(28)
            make.right.equalTo(gradientView.snp.right).offset(-28)
            make.bottom.equalTo(gradientView.snp.bottom).offset(-24)
            make.height.equalTo(48)
        }
        
        gradientView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        let marginGuide = self.view.layoutMarginsGuide
        self.buttonBottomConstraint = NSLayoutConstraint(item: marginGuide as Any,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: self.gradientView,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: 0)
        NSLayoutConstraint.activate([buttonBottomConstraint])
    }
    
    func configureKeyboardShowAction() {
        self.distanceBottomCalculus = { focusedField in
            return self.scrollView.frame.size.height - focusedField.frame.origin.y - focusedField.frame.size.height - self.gradientView.frame.size.height
        }
        self.showKeyboardAction = { notification in
            guard let focusedField = self.focusedField else {
                return
            }
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.buttonBottomConstraint.constant = 12
                if #available(iOS 11.0, *) {
                    self.keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
                } else {
                    self.keyboardHeight = keyboardSize.height
                }
                self.keyboardProtocol?.resizeScroll(keyboardSize: self.keyboardHeight)
                self.buttonBottomConstraint.constant += self.keyboardHeight
                let distanceToBottom = self.distanceBottomCalculus(focusedField)
                let collapseSpace = self.keyboardHeight - distanceToBottom
                if collapseSpace < 0 {
                    return
                }
                
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 47)
            }
        }
    }
    
    func configureKeyboardHideAction() {
        self.distanceBottomCalculus = { focusedField in
            return self.scrollView.frame.size.height - focusedField.frame.origin.y - focusedField.frame.size.height - self.gradientView.frame.size.height
        }
        self.hideKeyboardAction = { notification in
            if self.keyboardHeight != nil {
                self.buttonBottomConstraint.constant -= self.keyboardHeight
            }
            if self.lastOffset != nil {
                self.scrollView.contentOffset = self.lastOffset
            }
            self.keyboardHeight = nil
            self.keyboardProtocol?.resizeScroll(keyboardSize: self.keyboardHeight)
        }
    }
    
    @objc override func keyboardShow(notification: NSNotification) {
        showKeyboardAction?(notification)
        keyboardProtocol?.keyboardIsOpen(isOpen: true)
    }
    
    @objc override func keyboardHide(notification: NSNotification) {
        hideKeyboardAction?(notification)
        self.keyboardProtocol?.keyboardIsOpen(isOpen: false)
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        showKeyboardAction?(notification)
    }
    
    public func addContentView(_ view: UIView) {
        self.scrollView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.top)
            make.left.equalTo(self.scrollView.snp.left)
            make.right.equalTo(self.scrollView.snp.right)
        }
        
        scrollView.snp.remakeConstraints{ (make) in
            make.top.equalTo(self.ignoreTopSafeAreaMargin == true ? self.view.snp.top : self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(view.snp.width).multipliedBy(1)
        }
    }
    
    @objc private func nextStepButtonAction() {
        self.nextStepAction?()
    }
}
