//
//  SearchGroup.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 25.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

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

