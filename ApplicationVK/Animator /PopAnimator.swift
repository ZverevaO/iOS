//
//  PopAnimator.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 28.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var originFrame = CGRect.zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let recipeViwe = toView
        
        let finalFrame = recipeViwe.frame
        
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        recipeViwe.transform = scaleTransform
        recipeViwe.center = CGPoint(x: originFrame.midX, y: originFrame.minY)
        
        recipeViwe.clipsToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        recipeViwe.transform = .identity
                        recipeViwe.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) {isComplete in transitionContext.completeTransition(isComplete)}
        
    }

}
