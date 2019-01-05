//
//  TransitionCoordinator.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 05/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
