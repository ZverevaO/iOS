//
//  CustomNavigationController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 22.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//


import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        
    }
    
    let interactiveTransition = CustomInteractiveTransition()

}

extension CustomNavigationController : UINavigationControllerDelegate {
    
    

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
 func navigationController(_ navigationController: UINavigationController,
                           animationControllerFor operation: UINavigationController.Operation,
                           from fromVC: UIViewController,
                           to toVC: UIViewController)
                           -> UIViewControllerAnimatedTransitioning? {
     if operation == .push {
         self.interactiveTransition.viewController = toVC
          return CustomPushAnimator()
     } else if operation == .pop {
         if navigationController.viewControllers.first != toVC {
             self.interactiveTransition.viewController = toVC
         }
         return CustomPopAnimator()
     }
     return nil
 }
//    func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController)
//        -> UIViewControllerAnimatedTransitioning? {
//
//            switch operation {
//            case .push:
//               self.interactiveTransition.viewController = toVC
//               return CustomPushAnimator()
//            case .pop:
//                 if navigationController.viewControllers.first != toVC {
//                    self.interactiveTransition.viewController = toVC}
//                return CustomPopAnimator()
//            default:
//                return nil
//            }
//
//    }
            
}
