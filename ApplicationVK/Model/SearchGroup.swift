//
//  SearchGroup.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 25.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
//import Firebase

class FoundGroup: Decodable
{
    let id: Int
    let name: String
    let photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo50 = "photo_50"
        
    }
}

class VKFoundGroupsData: Decodable {
    let count: Int
    let items: [FoundGroup]
}

class VKFoundGroupsResponse: Decodable
{
    let response: VKFoundGroupsData
}

//class FireBaseUserGroups {
//    let userID: Int
//    let groupID: Int
//    let ref: DatabaseReference?
//    
//    init (userID: Int, groupID: Int) {
//        self.groupID = groupID
//        self.userID = userID
//        self.ref = nil
//    }
//    
//    init? (snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: Any],
//            let userID = value["userID"] as? Int,
//            let groupID = value["groupID"] as? Int else {
//                return nil
//        }
//        self.groupID = groupID
//        self.userID = userID
//        self.ref = snapshot.ref
//    }
//    
//    func toAnyObject() -> [String: Any] {
//        return [
//            "userID": userID,
//            "groupID": groupID
//        ]
//    }
//
//}
