//
//  FriendServiceInterface.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 16.08.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation

protocol FriendServiceInterface {
    func getFriends (completion: @escaping ([Friend]) -> Void)
}
