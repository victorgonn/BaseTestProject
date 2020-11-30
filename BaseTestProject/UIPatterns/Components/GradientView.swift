//
//  GradientView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 28/11/20.
//

import Foundation
import UIKit

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}

public class GradientView: UIView {
    var gradient = CAGradientLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configGradientView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configGradientView()
    }
    
    public init(color: UIColor = .white, startPoint: CGPoint = .zero, endPoint: CGPoint = CGPoint(x: 0, y: 1)) {
        super.init(frame: .zero)
        configGradientView(color, startPoint: startPoint, endPoint: endPoint)
    }

    public func configGradientView(_ color: UIColor = .white, startPoint: CGPoint = .zero, endPoint: CGPoint = CGPoint(x: 0, y: 1)) {
        gradient.colors = [color.withAlphaComponent(0.33).cgColor,
                           color.withAlphaComponent(0.66).cgColor,
                           color.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        layer.addSublayer(gradient)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}
