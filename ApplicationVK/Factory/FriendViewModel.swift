//
//  FriendViewModel.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 06.08.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class FriendViewModel {
    let nameFriend: String
    let statusFriend: String
    let avatarFriend: URL?
    let userId: Int
    
    init (nameFriend: String, statusFriend: String, avatarFriend: URL?, userId: Int)
    {
        self.nameFriend = nameFriend
        self.statusFriend = statusFriend
        self.avatarFriend = avatarFriend
        self.userId = userId
    }
    
}
