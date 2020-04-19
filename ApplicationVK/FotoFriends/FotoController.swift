//
//  FotoController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class FotoController: UIViewController {
    
    @IBOutlet weak var curentFoto: UIImageView!
    
    let arrayFoto: [String] = ["foto1","foto2","iconFriend1","iconFriend2"]
    var countFoto: Int = 0
    var Foto: UIImage!
    var interactiveAnimator: UIViewPropertyAnimator!
     var leftPanTriggered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

      let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
         
      self.view.addGestureRecognizer(swipeGestureRecognizer)

        
//        curentFoto.image = Foto
        curentFoto.image = UIImage(named: arrayFoto[countFoto])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    @objc func handleLeftEdge (_ recognizer: UIScreenEdgePanGestureRecognizer)
    {
        
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            if !leftPanTriggered {
                let threshold: CGFloat = 10  // you decide this
                let translation = abs(recognizer.translation(in: view).x)
                if translation >= threshold  {
                    
                    
                    leftPanTriggered = true
                }
            }
            else {
                
            }
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.x / 50
        // self.curentFoto.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        case .ended:
            
            
            interactiveAnimator.startAnimation()
        default: return
        }
        
        
    }

    @objc func swipeView (_ recognizer: UIPanGestureRecognizer) {
    
        switch recognizer.state {
        case .began:
            
            interactiveAnimator?.startAnimation()
            
            
            
            interactiveAnimator =   UIViewPropertyAnimator(duration: 0.4,
                                                           curve: .easeOut,
                                                           animations: {
//                                                            self.curentFoto.transform = CGAffineTransform(translationX: dx ,y: 0)
                                                            self.curentFoto.alpha = 0.5
//                                                            self.curentFoto.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            })
            
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.x / 100
            self.curentFoto.transform = CGAffineTransform(translationX: translation.x  ,y: 0)
        case .ended:
            interactiveAnimator.stopAnimation(true)
            if recognizer.translation(in: self.view).x > 0 {
                self.countFoto += 1
            }
            else {
                self.countFoto -= 1
            }
            interactiveAnimator.addAnimations {
                self.curentFoto.transform = .identity
                self.curentFoto.alpha = 1
                
            }
            
            interactiveAnimator.startAnimation()
        default: break
        }
        
        if countFoto == arrayFoto.count {countFoto = 0}
        else if countFoto < 0 { countFoto = arrayFoto.count - 1}
        curentFoto.image = UIImage(named: arrayFoto[countFoto])
        
    }
    
//    @objc func swipeView (_ recognizer: UIPanGestureRecognizer) {
  //        switch recognizer.direction {
  //        case .left: print("свайп в лево")
  //           countFoto += 1
  //        case .right: print ("свайп в право")
  //            countFoto += 1
  //
  //        default: print("свайп в другую сторону")
  //        }
  //        if countFoto < 0 {
  //            countFoto = arrayFoto.count - 1
  //        } else if countFoto == arrayFoto.count {
  //            countFoto = 0
  //        }
//          curentFoto.image = UIImage(named: arrayFoto[countFoto])
//
//      }
    
}


