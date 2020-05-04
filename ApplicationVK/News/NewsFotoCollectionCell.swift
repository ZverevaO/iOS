//
//  NewsFotoCollectionCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 13.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class NewsFotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var foto: UIImageView!
    
    var imageClicked: ((UIImageView)->())? = nil
    
    override func awakeFromNib() {
        foto.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        
        addGestureRecognizer(tapGesture)
    }
    
    @objc func pickImage() {
        imageClicked?(foto)
        
    }
    
    
}
