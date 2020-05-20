//
//  AllFriendTableCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class AllFriendTableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var foto: UIImageView!
   
    @IBOutlet weak var shadowFoto: CircleShadowImage!
    
    var userId: Int! 
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
