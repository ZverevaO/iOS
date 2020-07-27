//
//  DataNews.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 26.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class DataNews: Decodable {
    let items: [NewsItem]
    let profiles: [NewsProfile]
    let groups: [NewsGroup]
    let nextFrom: String
    
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
    
    init (items: [NewsItem], profiles: [NewsProfile],groups: [NewsGroup], nextFrom: String) {
        
        self.groups = groups
        self.items = items
        self.profiles = profiles
        self.nextFrom = nextFrom
        
    }
    
}
