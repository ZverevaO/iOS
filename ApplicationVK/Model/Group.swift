//
//  Group.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class Group: Comparable {
  
    
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
    let name: String
    var count: Int
    let gType: GroupType
    var fotoPath: String
    
    
    init(name: String, count: Int, gType: GroupType, fotoPath: String) {
        self.name = name
        self.count = count
        self.gType = gType
        self.fotoPath = fotoPath
    }
    
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Group, rhs: Group) -> Bool {
        return lhs.name < rhs.name
    }

}
