//
//  FotoController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class FotoController: UIViewController {
    
    @IBOutlet weak var curentFoto: UIImageView!
    
    var countFoto: Int = 0
    var Foto: UIImage!
    var interactiveAnimator: UIViewPropertyAnimator!
    var leftPanTriggered: Bool = false
    
    var photoUrl: URL!
    var userIdByPhotos: Int = 0
    var userPhoto : [VKPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataPhotoByFriend(userId: userIdByPhotos)
        
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
        
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        curentFoto.af.setImage(withURL: photoUrl!)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
            
    }
    
    
    
    func loadDataPhotoByFriend(userId: Int)
    {
        do {
            
            let realm = try Realm()
            let strFilter = "ownerId == " + String(userId)
            let photos = realm.objects(VKPhoto.self).filter(strFilter)
            self.userPhoto = Array(photos)
            
            print(self.self.userPhoto)
            
        }
        catch {
            print(error)
        }
        
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
                                                            // self.curentFoto.transform = CGAffineTransform(translationX: dx ,y: 0)
                                                            self.curentFoto.alpha = 0.5
                                                            // self.curentFoto.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
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
        
        if countFoto == userPhoto.count {countFoto = 0}
        else if countFoto < 0 { countFoto = userPhoto.count - 1}
        let strUrl = URL(string: userPhoto[countFoto].urlX)
        curentFoto.af.setImage(withURL: strUrl!)
        
        
    }
    
    
    
}


