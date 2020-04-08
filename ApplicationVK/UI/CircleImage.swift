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
    
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        addImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
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
