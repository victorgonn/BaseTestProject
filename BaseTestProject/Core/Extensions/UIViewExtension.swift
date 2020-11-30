//
//  UIViewExtension.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 29/11/20.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    public static func drawCircleBackgroundView(with color: UIColor,
                                                contrastColor: UIColor = .white,
                                                heightPercent: CGFloat = 0.6,
                                                circleCenterHeight: CGFloat = 0) -> UIView {
        
        
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backgroundView.backgroundColor = color
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: UIScreen.main.bounds.width/2, y: circleCenterHeight),
                                      radius: CGFloat(UIScreen.main.bounds.height * heightPercent),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath

        shapeLayer.fillColor = contrastColor.cgColor
        shapeLayer.strokeColor = contrastColor.cgColor
        shapeLayer.lineWidth = 3.0
        backgroundView.layer.addSublayer(shapeLayer)
        return backgroundView
    }
    
    public static func drawCircleBackgroundView(with backgroundImage: UIImage,
                                                heightPercent: CGFloat = 0.6,
                                                circleCenterHeight: CGFloat = 0) -> UIView {
        
        
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: UIScreen.main.bounds.width/2, y: circleCenterHeight),
                                      radius: CGFloat(UIScreen.main.bounds.height * heightPercent),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.contents = backgroundImage.cgImage
        shapeLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        shapeLayer.isGeometryFlipped = false
        shapeLayer.lineWidth = 3.0
        backgroundView.layer.addSublayer(shapeLayer)
        return backgroundView
    }

}

