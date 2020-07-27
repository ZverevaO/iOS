//
//  NewsGroups.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 26.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class NewsGroup: Decodable {
    let id: Int
    let name: String
    let photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo50 = "photo_50"
    }
    
   
}
