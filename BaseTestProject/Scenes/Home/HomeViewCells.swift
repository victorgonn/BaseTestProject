//
//  HomeViewCells.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation
import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    
    public lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var cellLabel: Label = {
        let headerLabel = Label()
        return headerLabel
    }()
    
    public lazy var cellImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()

    convenience init(imageUrl: String?, name: String, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        updateCell(imageUrl: imageUrl, name: name)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateCell(imageUrl: String?, name: String) {
        cellLabel.setStyle(FontStyle.f18PrimaryBold, text: name, color: UIColor.Theme.textColor2, enabledUppercase: true, numeberOfLines: 0, name: nil)
        containerView.backgroundColor = UIColor.random()
        if let _ = imageUrl {
            //Buscar Imagem da Internet (lazy Load)
        }
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        buildViewHierarchy()
        setupConstraints()
    }
    
    public func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(cellLabel)
        containerView.addSubview(cellImageView)
    }
    
    public func setupConstraints() {
        let width = self.frame.width
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left).offset(16)
            make.right.equalTo(snp.right).offset(-16)
            make.width.equalTo(width - 32)
            make.bottom.equalTo(snp.bottom)
        }
        
        cellImageView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(34)
            make.height.equalTo(52)
            make.width.equalTo(52)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        cellLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cellImageView.snp.bottom).offset(7)
            make.left.equalTo(snp.left).offset(16)
            make.right.equalTo(snp.right).offset(-16)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom).offset(-34)
        }
    }
}
