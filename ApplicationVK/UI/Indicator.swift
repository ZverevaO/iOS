//
//  Indicator.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 15.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class Indicator: UIView {
    
    @IBOutlet weak var indicator1: CircleImage!
    
    @IBOutlet weak var indicator2: CircleImage!
    
    @IBOutlet weak var indicator3: CircleImage!
    
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
                        self.indicator1.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.indicator1.alpha = 0.5
        }){_ in
            self.indicator1.alpha = 1
            self.indicator1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.3,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            self.indicator2.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.indicator2.alpha = 0.5
        }){_ in
            self.indicator2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             self.indicator2.alpha = 1
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.6,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            self.indicator3.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.indicator3.alpha = 0.5
        }){_ in
            self.indicator3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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

class CircleImage: UIView {
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func layoutSubviews() {

        //работа с тенью
        layer.shadowColor = UIColor.black.cgColor //устанавливаем цвет
        layer.shadowOpacity = 1.0 //устанавливаем прозрачность
        layer.shadowRadius = 4 //устанавоиваем радиус тени
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
            
    }
    
}

