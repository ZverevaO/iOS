//
//  FotoCollectionCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage

class FotoCollectionCell: UICollectionViewCell {
        
    @IBOutlet weak var foto: UIImageView!
    var urlPhoto: URL!
    var ownerId: Int = 0
   
    
    @IBAction func clickLike(_ sender: LikeButton) {
        
        sender.like()
    }
    
    @IBAction func commentButton(_ sender: CommentButton) {
        
        sender.clicked()
    }
    
}
