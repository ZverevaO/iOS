//
//  FriendAdapter.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 06.08.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import  RealmSwift

class FriendAdapter: FriendServiceInterface {
    
    private let friendService = FriendService()
    private var token: NotificationToken?
    func getFriends (completion: @escaping ([Friend]) -> Void) {
        
        guard let realm = try? Realm()
            else {
                return
        }
        
        print ("адаптер")
        let rlmFrends = realm.objects(MyFrineds.self).filter("firstName != %@","DELETED")
        
        token = rlmFrends.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmFriends, _, _, _):
                var friends: [Friend] = []
                
                for realmFriend in realmFriends {
                    friends.append(self.friend(from: realmFriend))
                }
                print("адаптер \(friends.count)")
                completion(friends)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        
        FriendService.loadAllFriends()
        
    }
    
    private func friend (from rlmFriend: MyFrineds) -> Friend {
        return Friend(id: rlmFriend.id,
                      firstName: rlmFriend.firstName,
                      lastLame: rlmFriend.lastLame,
                      sex: rlmFriend.sex,
                      photo50: rlmFriend.photo50,
                      online: rlmFriend.online)
    }
    
}
