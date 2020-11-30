//
//  HomeView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import UIKit
import SnapKit

class HomeView: BaseView {
    let headerBackGroundImageView: UIImageView = {
        let background = UIImageView(image: UIImage(named: "homeHeaderBackground"))
        background.contentMode = .scaleToFill
        return background
    }()
        
    let searchField = SearchField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        searchField.configureTextField(placeholder: "Pesquise por empresa")
        searchField.setTextFieldTag(with: 1)
        buildViewHierarchy()
        setupConstraints()
    }
    
    public func buildViewHierarchy() {
        addSubview(headerBackGroundImageView)
        addSubview(searchField)
    }
    
    public func setupConstraints() {
        headerBackGroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(190)
        }
        
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(headerBackGroundImageView.snp.bottom).offset(-24)
            make.left.equalTo(snp.left).offset(16)
            make.right.equalTo(snp.right).offset(-16)
            make.bottom.equalTo(snp.bottom).offset(-10)
        }

    }
    
    public func rebuildHeaderConstraints(headerType: HeaderType) {
        switch headerType {
        case .thin:
            headerBackGroundImageView.image = UIImage(named: "homeHeaderBackgroundThin")
            headerBackGroundImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(snp.top)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.height.equalTo(70)
            }
    
        default:
            headerBackGroundImageView.image = UIImage(named: "homeHeaderBackground")
            headerBackGroundImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(snp.top)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.height.equalTo(190)
            }
            
        }
    }
}
