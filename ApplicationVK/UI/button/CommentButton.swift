//
//  CommentButton.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 13.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class CommentButton: UIButton {
   
    var click: Bool = false
    var countCount: Int = 0
    
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
        setImage(UIImage(named: "iconcomm"), for: .normal)
           setTitle(String(describing: countCount), for: .normal)
           tintColor = .gray
           
           imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        imageView?.contentMode = .scaleAspectFit
       }
    
    }
    
