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

class  AllFriends  {
    static func getAllFriend () -> [Friend] {
        return [Friend(sex: Friend.Sex.male, name: "Вася", surName: "Васильев", age: 23, city: "Пермь", fotoPath: "iconFriend1", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Петя", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Ваня", surName: "Иванов", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Иван", surName: "Иванов", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Алексей", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Борис", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Роман", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Эдуарт", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Юрий", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false),
        Friend(sex: Friend.Sex.male, name: "Дмитрий", surName: "Петров", age: 33, city: "Анапа", fotoPath: "iconFriend2", isOnLine: false)]
    }
}
