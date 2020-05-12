//
//  Session.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
class Session {
    
    static let instance = Session()
    
    private init (){}
    
    var token: String = ""
    var userId: Int = 0
}
