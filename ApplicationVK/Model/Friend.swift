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
    let name: String
    let surName: String
    var age: Int
    let city: String
    let sex: Sex
    var fotoPath: String
    var isOnLine: Bool
    
    init(sex: Sex, name: String, surName: String, age: Int, city: String, fotoPath: String, isOnLine: Bool) {
        self.sex = sex
        self.name = name
        self.surName = surName
        self.age = age
        self.city = city
        self.fotoPath = fotoPath
        self.isOnLine = isOnLine 
    }
}
