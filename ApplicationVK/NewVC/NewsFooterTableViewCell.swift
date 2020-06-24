//
//  NewsFooterTableViewCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 21.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class NewsFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var likeBtn: LikeButton!
    
    @IBOutlet weak var commentBtn: CommentButton!
    
    @IBOutlet weak var shareBtn: ShareButton!
    
    @IBOutlet weak var viewBtn: ViewButton!
    
    
    
    @IBAction func likeClick(_ sender: LikeButton) {
        sender.like()
    }
    
    
    @IBAction func commentClick(_ sender: Any) {
    }
    
    
    @IBAction func shareClick(_ sender: Any) {
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
