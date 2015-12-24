//
//  SlideUpTransitionAnimator.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/24.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit

class SlideUpTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    var duration = 0.5
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let container = transitionContext.containerView()!
        let offScreenUp = CGAffineTransformMakeTranslation(0, -container.frame.height)
        let offScreenDown = CGAffineTransformMakeTranslation(0, container.frame.height)
        
        toView.transform = offScreenUp
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                fromView.transform = offScreenDown
                fromView.alpha = 0.5
                toView.transform = CGAffineTransformIdentity
            }, completion: {finished in
                transitionContext.completeTransition(true)
        })
    }

}
