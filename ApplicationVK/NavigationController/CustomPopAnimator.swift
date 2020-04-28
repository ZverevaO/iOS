//
//  CustomPopAnimator.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 22.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

let durationTime = 0.65

final class CustomPopAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationTime
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let source = transitionContext.viewController(forKey: .from) else { return }
        let source = transitionContext.viewController(forKey: .from)!
//        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        let destination = transitionContext.viewController(forKey: .to)!
        
        print("start animations")
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame

        destination.view.layer.anchorPoint = CGPoint(x :0, y: 0)
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        destination.view.transform = CGAffineTransform(rotationAngle: .pi/2)
        
        
        source.view.layer.anchorPoint = CGPoint(x :1, y: 0)
        source.view.layer.position = CGPoint(x: source.view.frame.width, y: 0)
        
        UIView.animateKeyframes(withDuration: durationTime,
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: -.pi/2)
                                                        source.view.transform = translation
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: 0)
                                                        destination.view.transform = translation
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.65,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
                                    
                                    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
                 print (" animations")
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
                print ("finish animations")
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
}
