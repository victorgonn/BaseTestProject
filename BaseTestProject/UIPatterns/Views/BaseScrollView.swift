//
//  BaseScrollView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import SnapKit

protocol KeyboardIsUpProtocol {
    func resizeScroll(keyboardSize: CGFloat?)
}

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
    
    var keyboardProtocol: KeyboardIsUpProtocol?
    
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
        self.configureKeyboardShowAction()
        self.configureKeyboardHideAction()
        //automaticallyAdjustsScrollViewInsets = false
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
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
        self.view.backgroundColor = .white
        //self.automaticallyAdjustsScrollViewInsets = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureTapAction()
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
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
            self.view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            self.nextStepButton.bottomAnchor.constraint(equalTo: self.gradientView.bottomAnchor, constant: -24),
            self.nextStepButton.trailingAnchor.constraint(equalTo: self.gradientView.trailingAnchor, constant: -24),
            self.nextStepButton.leadingAnchor.constraint(equalTo: self.gradientView.leadingAnchor, constant: 24),
            self.nextStepButton.topAnchor.constraint(equalTo: self.gradientView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            self.gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.gradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
        
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
    
    @objc func keyboardShow(notification: NSNotification) {
        showKeyboardAction?(notification)
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        hideKeyboardAction?(notification)
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        showKeyboardAction?(notification)
    }
    
    public func configureTapAction() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func keyboardDismiss() {
        view.endEditing(true)
    }
    
    public func setFocusOnField(uiField: TextField?) {
        if let selectedField = uiField {
           _ = selectedField.becomeFirstResponder()
        }
    }
    
    public func addContentView(_ view: UIView) {
        self.scrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            self.scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        ])
    }
    
    @objc private func nextStepButtonAction() {
        self.nextStepAction?()
    }
}
