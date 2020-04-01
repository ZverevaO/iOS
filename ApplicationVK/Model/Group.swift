//
//  Group.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class Group {
    enum GroupType: CustomStringConvertible {
        case cityGroup
        case history
        case cafe
        case business
        var description: String
        {
            switch self {
            case .cityGroup:
                return "городское сообщество"
            case .history:
                return "история"
            case .cafe:
                return "кафе, рестораны"
            case .business:
                return "бизнес"
            }
        }
    }
    let Name: String
    var Count: Int
    let GType: GroupType
    
    
    init(name: String, count: Int, gType: GroupType) {
        self.Name = name
        self.Count = count
        self.GType = gType
    }
}
