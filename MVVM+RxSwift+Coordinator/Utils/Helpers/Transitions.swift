//
//  Transitions.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 05/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit
import SnapKit

class Scale: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration = 0.2
    public var presenting = true
    public var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else { return }
        var from: UIView
        if presenting {
            from = toView
        } else {
            from = fromView
        }
        
        let containerView = transitionContext.containerView
        
        let initialFrame = presenting ? originFrame : from.frame
        let finalFrame = presenting ? from.frame : CGRect(x: 0, y: 0, width: originFrame.width, height: 0.1)
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
        0.1
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            from.transform = scaleTransform
            from.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            from.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(from)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       animations: {
                        from.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        from.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}


class ToSearch: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration = 0.35
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVc = transitionContext.viewController(forKey: .to) as? CoinsSearchViewController,
            let fromVc = transitionContext.viewController(forKey: .from) as? CoinsViewController,
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView        

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(fromView)
        
        fromVc.searchTextField.snp.updateConstraints {
            $0.leading.equalTo(fromView.snp.leadingMargin)
            $0.top.equalTo(fromView.snp.topMargin)
            $0.trailing.equalTo(fromView.snp.trailingMargin).inset(42)
            $0.height.equalTo(30)
        }
        
        toVc.searchTextField.alpha = 0.0
        
        toVc.dismissButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            fromVc.coinsScrollView.alpha = 0.0
            fromVc.view.backgroundColor = .clear
            fromView.layoutIfNeeded()
            toView.layoutIfNeeded()
        }, completion: { _ in
            toVc.searchTextField.alpha = 1.0
            toVc.searchTextField.becomeFirstResponder()
            transitionContext.completeTransition(true)
        })
    }
    
}

class FromSearch: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration = 2.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVc = transitionContext.viewController(forKey: .to) as? CoinsViewController,
            let fromVc = transitionContext.viewController(forKey: .from) as? CoinsSearchViewController,
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(fromView)
        
        toVc.view.backgroundColor = .white
        toVc.coinsScrollView.alpha = 1.0
        toVc.searchTextField.alpha = 1.0
        
        toVc.searchTextField.snp.updateConstraints {
            $0.leading.equalTo(toView.snp.leadingMargin).offset(10)
            $0.top.equalTo(toView.snp.topMargin).offset(40)
            $0.trailing.equalTo(toView.snp.trailingMargin).inset(10)
            $0.height.equalTo(35)
        }
        
        fromVc.dismissButton.snp.makeConstraints {
            $0.leading.equalTo(fromView.snp.leadingMargin)
            $0.top.equalTo(fromView.snp.top)
            $0.height.equalTo(0)
            $0.width.equalTo(0)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            fromVc.searchTextField.frame.origin = toVc.searchTextField.frame.origin
                        
            fromVc.view.backgroundColor = .clear
            fromView.layoutIfNeeded()
        }, completion: { _ in
            toVc.searchTextField.alpha = 1.0
            toVc.searchTextField.endEditing(true)
            transitionContext.completeTransition(true)
        })
    }
    
}
