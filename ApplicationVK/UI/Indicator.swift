//
//  Indicator.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 15.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class Indicator: UIView {
    
    @IBOutlet weak var indicator1: CircleShadowImage1!
    
    @IBOutlet weak var indicator2: CircleShadowImage1!
    
    @IBOutlet weak var indicator3: CircleShadowImage1!
    
    var contentView: UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup ()
       

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        xibSetup ()

    }
    
    func animate () {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
                        //self.indicator2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        self.indicator1.alpha = 0.5
        }){_ in
            self.indicator1.alpha = 1
            //            self.indicator1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.3,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            //self.indicator2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        self.indicator2.alpha = 0.5
        }){_ in
           // self.indicator2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             self.indicator2.alpha = 1
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.6,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            //self.indicator3.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        self.indicator3.alpha = 0.5
        }){_ in
            //self.indicator3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             self.indicator3.alpha = 1
            
        }
                      
    }
    
    func xibSetup () {
        
        contentView = loadFromXIB()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        animate()
        
    }
    
    func loadFromXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return xib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
}

class CircleShadowImage1: UIView {
    
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
        image.image = UIImage(named: "grey")
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

