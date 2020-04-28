//
//  CustomPushAnimator.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 22.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//
import UIKit
let durationTimePush = 0.65

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationTimePush
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let source = transitionContext.viewController(forKey: .from) else { return }
        let source = transitionContext.viewController(forKey: .from)!
//        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        let destination = transitionContext.viewController(forKey: .to)!
  
        transitionContext.containerView.addSubview(destination.view)
       
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.layer.position = CGPoint(x: destination.view.frame.width, y: 0)
        destination.view.transform =  CGAffineTransform(rotationAngle: -(.pi/2))
  
        source.view.layer.anchorPoint = CGPoint(x :0, y: 0)
        source.view.layer.position = CGPoint(x: 0, y: 0)
   
        UIView.animateKeyframes(withDuration: durationTimePush,
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.65,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: .pi/2)
                                                        source.view.transform = translation
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.65,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: 0)
                                                        destination.view.transform = translation
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
        
        
    }
    
    
}

