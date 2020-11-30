//
//  DetailView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import UIKit
import SnapKit

class DetailView: BaseView {
    public lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var headerLabel: Label = {
        let headerLabel = Label()
        headerLabel.textAlignment = .center
        return headerLabel
    }()
    
    public lazy var hedaerImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    public lazy var detailsLabel: Label = {
        let headerLabel = Label()
        headerLabel.textAlignment = .left
        return headerLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        buildViewHierarchy()
        setupConstraints()
    }
    
    func configureView(title: String, headerColor: UIColor, description: String) {
        containerView.backgroundColor = headerColor
        headerLabel.setStyle(FontStyle.f18PrimaryBold, text: title, color: UIColor.Theme.textColor2, enabledUppercase: true, numeberOfLines: 0, name: nil)
        detailsLabel.setStyle(FontStyle.f18PrimaryRegular, text: description, color: UIColor.Theme.textColor0, enabledUppercase: false, numeberOfLines: 0, name: nil)
    }
    
    public func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(hedaerImageView)
        containerView.addSubview(headerLabel)
        addSubview(detailsLabel)
    }
    
    public func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(120)
        }
        
        hedaerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(34)
            make.height.equalTo(52)
            make.width.equalTo(52)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hedaerImageView.snp.bottom).offset(7)
            make.left.equalTo(snp.left).offset(16)
            make.right.equalTo(snp.right).offset(-16)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        detailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom).offset(24)
            make.left.equalTo(snp.left).offset(17)
            make.right.equalTo(snp.right).offset(-17)
        }
    }
}
