//
//  CircleImage.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 04.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
class CircleShadowImage: UIView {
    
    public var image: UIImageView!
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func  tapView () {
        viewAnimation ()
    }
    
    func viewAnimation () {
        let animation = CASpringAnimation (keyPath: "transform.scale")
        animation.fromValue = 0.5
        animation.toValue = 1.0
        animation.stiffness = 500
        animation.mass = 1
        animation.duration = 1
        animation.fillMode = CAMediaTimingFillMode.both
        layer.add(animation, forKey: nil)
    }
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        addImage()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addImage() {
        image = UIImageView(frame: frame)
        addSubview(image)
    }
    
    override func layoutSubviews() {
        image.frame = bounds
        
        layer.backgroundColor = UIColor.clear.cgColor
        //работа с тенью
        layer.shadowColor = UIColor.black.cgColor //устанавливаем цвет
        layer.shadowOpacity = 1.0 //устанавливаем прозрачность
        layer.shadowRadius = 4 //устанавоиваем радиус тени
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        //скругляем аватар
        image.layer.cornerRadius = bounds.size.height / 2
        image.layer.masksToBounds = true
        
    }
    
}
