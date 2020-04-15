//
//  Indicator.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 15.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class Indicator: UIView {
    
    @IBOutlet weak var indicator1: CircleShadowImage!
    
    @IBOutlet weak var indicator2: CircleShadowImage!
    
    @IBOutlet weak var indicator3: CircleShadowImage!
    
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup ()
        animate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup ()
        animate()
    }
    
    func xibSetup () {
        contentView = loadFromXIB()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
    }
    
    func loadFromXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return xib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    func animate () {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            self.indicator1.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }){_ in
            self.indicator1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.3,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            self.indicator2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }){_ in
            self.indicator2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.6,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
            self.indicator3.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }){_ in
            self.indicator3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }
                      
    }
    
}
