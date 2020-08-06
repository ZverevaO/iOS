//
//  NewsOnePhotoTableViewCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 21.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsOnePhotoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var photoPost: UIImageView!

    let cellType: typeCell = .photos
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure (photoURL: URL?) {
        
        if let uPhotoURL = photoURL {
            self.photoPost.af.setImage(withURL: uPhotoURL)
        }
        else {
            self.photoPost.image = UIImage(named: "iconFriend1")
        }
        
 
    }
    
}
