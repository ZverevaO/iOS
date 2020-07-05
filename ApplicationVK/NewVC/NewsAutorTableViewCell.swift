//
//  NewsAutorTableViewCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 21.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsAutorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatar: UIImageView!
    
    @IBOutlet private weak var autorName: UILabel!
    
    @IBOutlet private weak var time: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure (autorName: String, time: String, avatarURL: URL?) {
        
        self.autorName.text = autorName
        self.time.text = time
        
        if let uAvatarURL = avatarURL {
            self.avatar.af.setImage(withURL: uAvatarURL)
        }
        else {
            self.avatar.image = UIImage(named: "iconFriend1")
        }
    }
}
