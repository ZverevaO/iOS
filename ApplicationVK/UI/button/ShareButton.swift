//
//  ShareButton.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 17.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class ShareButton: UIButton {
   
    var click: Bool = false
    var countShare: Int = 0
       
    func clicked()  {
           click = !click
           
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
           setImage(UIImage(named: "strelka1"), for: .normal)
           setTitle(String(describing: countShare), for: .normal)
           tintColor = .gray
           
           imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
           titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: -5)
           imageView?.contentMode = .scaleAspectFit
       }
    
    }
    
