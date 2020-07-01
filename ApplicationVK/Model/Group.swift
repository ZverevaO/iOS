//
//  Group.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import RealmSwift

class VKGroup: Object, Decodable, Comparable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var membersCount: Int = 0
    @objc dynamic var photo50: String = ""
    
    enum CodingKeys: String, CodingKey {
           case id
           case name
           case screenName = "screen_name"
           case membersCount = "members_count"
           case photo50 = "photo_50"
           
       }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func == (lhs: VKGroup, rhs: VKGroup) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: VKGroup, rhs: VKGroup) -> Bool {
        return lhs.name < rhs.name
    }
     
}

class VKGroupsData: Decodable {
    let count: Int
    let items: [VKGroup]
}

class VKGroupsResponse: Decodable
{
    let response: VKGroupsData
}





