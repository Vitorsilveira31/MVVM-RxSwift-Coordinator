//
//  UIView.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit
import SnapKit

public extension UIView {
    
    public func addSubviewAttachingEdges(_ view: UIView,
                                         leadingConstraint: ConstraintItem? = nil,
                                         topConstraint: ConstraintItem? = nil,
                                         trailingConstraint: ConstraintItem? = nil,
                                         bottomConstraint: ConstraintItem? = nil) {
        addSubview(view)
        
        attachEdges(view,
                    leadingConstraint: leadingConstraint ?? self.snp.leading,
                    topConstraint: topConstraint ?? self.snp.top,
                    trailingConstraint: trailingConstraint ?? self.snp.trailing,
                    bottomConstraint: bottomConstraint ?? self.snp.bottom)
    }
    
    public func attachEdges(_ view: UIView,
                            leadingConstraint: ConstraintItem,
                            topConstraint: ConstraintItem,
                            trailingConstraint: ConstraintItem,
                            bottomConstraint: ConstraintItem) {
        view.snp.makeConstraints {
            $0.leading.equalTo(leadingConstraint)
            $0.top.equalTo(topConstraint)
            $0.trailing.equalTo(trailingConstraint)
            $0.bottom.equalTo(bottomConstraint)
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
        }
    }
    
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    private var shimmerTag: Int { return 00001 }
    
    public func addShimmering() {
        if !self.subviews.filter({ $0.tag == self.shimmerTag }).isEmpty {
            return
        }
        
        let shimmerView = UIView(frame: self.frame)
        shimmerView.tag = self.shimmerTag
        shimmerView.cornerRadius = self.cornerRadius
        shimmerView.backgroundColor = UIColor.gray
        
        let light = UIColor.white.withAlphaComponent(0.2).cgColor
        let dark = UIColor.gray.withAlphaComponent(0.4).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [light, dark, light]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.3, 0.4, 0.5, 0.6]
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 0.8
        animation.repeatCount = .infinity
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.addSubviewAttachingEdges(shimmerView)
            
            shimmerView.layer.mask = gradient
            gradient.add(animation, forKey: "shimmer")
        }
    }
    
    func removeShimmering() {
        DispatchQueue.main.async {
            self.subviews.forEach {
                if $0.tag == self.shimmerTag {
                    $0.layer.mask = nil
                    $0.removeFromSuperview()
                }
            }
        }
    }
}
