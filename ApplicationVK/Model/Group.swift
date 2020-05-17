//
//  Group.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire

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



class VKGroup: Decodable, Comparable {
    let id: Int
    let name: String
    let screen_name: String
    let members_count: Int
    let photo_50: String
    
    
    static func == (lhs: VKGroup, rhs: VKGroup) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: VKGroup, rhs: VKGroup) -> Bool {
        return lhs.name < rhs.name
    }
    
}

class VKGroupsData: Decodable {
    let count: Int
    let items: [VKGroup]
}

class VKGroupsResponse: Decodable
{
    let response: VKGroupsData
}



class VKGroupsService
{
    static func loadGroupsUser (completion: @escaping ([VKGroup]) -> Void)
    {
        AF.request("https://api.vk.com/method/groups.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "user_id" : Session.instance.userId,
                    "extended" : "1",
                    "fields" : "description,members_count",
                    "v" : "5.103"
        ]).responseData {
            response in
            guard let data = response.value else {return}
            do {
                let dataVKGroups =  try JSONDecoder().decode(VKGroupsResponse.self, from: data).response.items
                completion(dataVKGroups)
                print(response.value)
            }
            catch{
                print(error)
            }
            
        }
    }
}


