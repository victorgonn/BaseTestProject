//
//  LoadingView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import UIKit
import SnapKit

class LoadingView: UIView, ConfigurableView {
    
    fileprivate var loadingImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "loading"))
        image.contentMode = .scaleToFill
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        customizeView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func customizeView() {
        backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }
    
    func buildViewHierarchy() {
        addSubview(loadingImage)
     }
     
    func setupConstraints() {
        loadingImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(72)
            make.height.equalTo(72)
        }
    }

}
