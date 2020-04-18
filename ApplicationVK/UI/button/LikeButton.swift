//
//  LikeButton.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 05.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    var liked: Bool = false
    
    var likeCount = 0
    
    func like()  {
        liked = !liked
        
        if liked {
            setlike()
        }
        else {
            disableLike()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault ()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefault ()
    }
    
    private func setupDefault ()
    {
        setImage(UIImage(named: "dislike"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .gray
        
        imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        imageView?.contentMode = .scaleAspectFit
    }
    
    private func setlike () {
        
        likeCount += 1
        
        setImage(UIImage(named: "like"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .red
        animatedLikeButton ()
    }
    
    private func disableLike () {
        
        likeCount -= 1
        setImage(UIImage(named: "dislike"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .gray
        animatedLikeButton ()
    }
    
    private func animatedLikeButton () {
        let animation = CASpringAnimation (keyPath: "transform.scale")
        animation.fromValue = 1.1
        animation.toValue = 1
        animation.stiffness = 500
        animation.mass = 1
        animation.duration = 1
        animation.fillMode = CAMediaTimingFillMode.both
        layer.add(animation, forKey: nil)
    
    }
}
