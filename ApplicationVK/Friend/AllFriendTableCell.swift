//
//  AllFriendTableCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage

class AllFriendTableCell: UITableViewCell {
    
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.translatesAutoresizingMaskIntoConstraints = false
            name.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var status: UILabel! {
        didSet{
            status.translatesAutoresizingMaskIntoConstraints = false
            status.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var shadowPhoto: CircleShadowImage! {
        didSet {
            shadowPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private var userId: Int = 0
    
    private let iconViewHeight: CGFloat = 55
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconShadowFrame()
        nameLabelFrame()
        statusLabelFrame()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
    func configure (with viewModel: FriendViewModel)
    {
        name.text = viewModel.nameFriend
        status.text = viewModel.statusFriend
        
        if let uAvatarURL = viewModel.avatarFriend {
            shadowPhoto.image.af.setImage(withURL: uAvatarURL)
        }
        else {
            shadowPhoto.image.image = UIImage(named: "iconFriend1")
        }
        
        self.userId = viewModel.userId
        
    }
    
    func getUser () -> Int
    {
        return userId
    }
    
    private func iconShadowFrame() {
        
        shadowPhoto.frame = CGRect(x: floor(contentView.bounds.minX + 10),
                                   y: floor(contentView.bounds.midY - iconViewHeight/2),
                                   width: iconViewHeight,
                                   height: iconViewHeight)
    }
    
    private func nameLabelFrame () {
        
        let origin = CGPoint(x: iconViewHeight + 20,
                             y: floor(contentView.bounds.midY - name.intrinsicContentSize.height/2))
        
        let size = CGSize(width: ceil(name.intrinsicContentSize.width),
                          height: ceil(name.intrinsicContentSize.height))
        
        name.frame = CGRect(origin: origin, size: size)
        
    }
    
    private func statusLabelFrame () {
        
        let origin = CGPoint(x: iconViewHeight + 20,
                             y: floor(contentView.bounds.midY + name.intrinsicContentSize.height/2) + 2)
        
        let size = CGSize(width: ceil(status.intrinsicContentSize.width),
                          height: ceil(status.intrinsicContentSize.height))
        
        status.frame = CGRect(origin: origin, size: size)
        
    }
    
    //старая реализация
    //    func configure (nameFriend: String, onlineStatus: String, avatarURL: URL?, userId: Int )
    //    {
    //        name.text = nameFriend
    //        status.text = onlineStatus
    //
    //        if let uAvatarURL = avatarURL {
    //            shadowPhoto.image.af.setImage(withURL: uAvatarURL)
    //        }
    //        else {
    //            shadowPhoto.image.image = UIImage(named: "iconFriend1")
    //        }
    //
    //        self.userId = userId
    //
    //    }
    
}
