//
//  Animations.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 11/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    private let color: UIColor
    private let duration: CFTimeInterval
    
    init(color: UIColor, animationDuration: CFTimeInterval = 0.65) {
        self.color = color
        self.duration = animationDuration
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func commomInit() {
        layoutIfNeeded()
        
        let size = (bounds.width / 3) * 0.7
        
        let loader1 =  UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let ovalLayer1 = OvalLayer(maxSize: CGRect(x: 0, y: 0, width: size, height: size), color: color, animationDuration: duration)
        loader1.layer.addSublayer(ovalLayer1)
        
        let loader2 =  UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let ovalLayer2 = OvalLayer(maxSize: CGRect(x: 0, y: 0, width: size, height: size), color: color, animationDuration: duration)
        loader2.layer.addSublayer(ovalLayer2)
        
        let loader3 =  UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let ovalLayer3 = OvalLayer(maxSize: CGRect(x: 0, y: 0, width: size, height: size), color: color, animationDuration: duration)
        loader3.layer.addSublayer(ovalLayer3)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            ovalLayer1.animate()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration * 0.4)) {
            ovalLayer2.animate()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration * 0.7)) {
            ovalLayer3.animate()
        }
        
        self.addSubview(loader1)
        self.addSubview(loader2)
        self.addSubview(loader3)
        
        loader2.snp.makeConstraints {
            $0.leading.equalTo(loader1.snp.trailing).offset(5)
            $0.centerY.equalTo(self.snp.centerY)
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(size)
            $0.height.equalTo(size)
        }
        
        loader1.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.equalTo(size)
            $0.height.equalTo(size)
        }
        
        loader3.snp.makeConstraints {
            $0.leading.equalTo(loader2.snp.trailing).offset(5)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.equalTo(size)
            $0.height.equalTo(size)
        }
    }
    
}

private class OvalLayer: CAShapeLayer {
    
    private let animationDuration: CFTimeInterval
    private let maxSize: CGRect
    private let initialOpacity = 0.1
    private let finalOpacity = 1.0
    
    init(maxSize: CGRect, color: UIColor, animationDuration: CFTimeInterval = 0.65) {
        self.maxSize = maxSize
        self.animationDuration = animationDuration
        super.init()
        
        fillColor = color.cgColor
        path = ovalPathSmall.cgPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var ovalPathSmall: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: (self.maxSize.width - (self.maxSize.width * 0.8)) / 2,
                                           y: (self.maxSize.width - (self.maxSize.width * 0.8)) / 2,
                                           width: self.maxSize.width * 0.8,
                                           height: self.maxSize.height * 0.8))
    }
    
    private var ovalPathLarge: UIBezierPath {
        return UIBezierPath(ovalIn: self.maxSize)
    }
    
    public func animate() {
        wobble()
        opacity()
    }
    
    private func wobble() {
        let wobbleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        wobbleAnimation1.fromValue = ovalPathSmall.cgPath
        wobbleAnimation1.toValue = ovalPathLarge.cgPath
        wobbleAnimation1.beginTime = 0.0
        wobbleAnimation1.duration = animationDuration
        
        let wobbleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        wobbleAnimation2.fromValue = ovalPathLarge.cgPath
        wobbleAnimation2.toValue = ovalPathSmall.cgPath
        wobbleAnimation2.beginTime = wobbleAnimation1.beginTime + wobbleAnimation1.duration
        wobbleAnimation2.duration = animationDuration
        
        let wobbleAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        wobbleAnimationGroup.animations = [wobbleAnimation1, wobbleAnimation2]
        wobbleAnimationGroup.duration = wobbleAnimation2.beginTime + wobbleAnimation2.duration
        wobbleAnimationGroup.repeatCount = .infinity
        add(wobbleAnimationGroup, forKey: nil)
    }
    
    private func opacity() {
        let opacityAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation1.fromValue = initialOpacity
        opacityAnimation1.toValue = finalOpacity
        opacityAnimation1.beginTime = 0.0
        opacityAnimation1.duration = animationDuration
        
        let opacityAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation2.fromValue = finalOpacity
        opacityAnimation2.toValue = initialOpacity
        opacityAnimation2.beginTime = opacityAnimation1.beginTime + opacityAnimation1.duration
        opacityAnimation2.duration = animationDuration
        
        let opacityAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        opacityAnimationGroup.animations = [opacityAnimation1, opacityAnimation2]
        opacityAnimationGroup.duration = opacityAnimation2.beginTime + opacityAnimation2.duration
        opacityAnimationGroup.repeatCount = .infinity
        add(opacityAnimationGroup, forKey: nil)
    }
}
