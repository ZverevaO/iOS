//
//  FriendViewModelFactory.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 06.08.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class FriendViewModelFactory {
    
    func constructViewModels(from friends: [Friend]) -> [FriendViewModel] {
        return friends.compactMap(self.friendViewModel)
    }
    
    private func friendViewModel (from friend: Friend) -> FriendViewModel {
        
        let nameFriend = friend.firstName + " " + friend.lastLame
        
        var online = ""
        if friend.online == 1 {
            online = "online"
        }
        
        let url = URL(string: friend.photo50)
        
        return FriendViewModel(nameFriend: nameFriend, statusFriend: online, avatarFriend: url, userId: friend.id)
    }
}
