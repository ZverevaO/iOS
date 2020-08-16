//
//  FriendServiceProxy.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 16.08.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class FriendServiceProxy: FriendServiceInterface {
    
    let friendService: FriendAdapter
    init (friendService: FriendAdapter) {
        self.friendService = friendService
    }
    
    func getFriends(completion: @escaping ([Friend]) -> Void) {
        self.friendService.getFriends(completion: completion)
        
        let date = NSDate()
        print("request for a friend \(date)")

    }
    
    
}
