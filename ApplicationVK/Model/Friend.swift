//
//  Friend.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

class Friend {
    enum Sex: CustomStringConvertible {
        case male
        case female
        var description: String
        {
            switch self {
            case .male:
                return "мужчина"
            case .female:
                return "женищина"
            }
        }
    }
    let Name: String
    let SurName: String
    var Age: Int
    let City: String
    let Sex: Sex
    
    init(sex: Sex, name: String, surName: String, age: Int, city: String) {
        self.Sex = sex
        self.Name = name
        self.SurName = surName
        self.Age = age
        self.City = city
    }
}
