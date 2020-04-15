//
//  MyGroupTableCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class MyGroupTableCell: UITableViewCell {
    
  
    @IBOutlet weak var iconShadow: CircleShadowImage!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var groupType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
