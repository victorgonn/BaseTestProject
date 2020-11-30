//
//  GradientView.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 28/11/20.
//

import Foundation
import UIKit

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
