//
//  FotoCollectionCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class FotoCollectionCell: UICollectionViewCell {
        
    @IBOutlet weak var foto: UIImageView!
    
    
    @IBAction func clickLike(_ sender: LikeButton) {
        
        sender.like()
    }
    
    
}
