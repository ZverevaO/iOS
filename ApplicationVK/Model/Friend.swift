//
//  Friend.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire


class MyFrineds: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let sex: Int
    //    let bdate: String?
    let photo_50: String
    let online: Int
    
    enum FriendCodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case sex
        //        case bdate
        case photo_50
        case online
        
    }
    
    
    
    //    init(from decoder: Decoder) throws {
    //
    //        let values = try decoder.container(keyedBy: FRCodingKeys.self)
    //
    //        var listFriends = try values.nestedUnkeyedContainer(forKey: .items)
    //        let first = try listFriends.nestedContainer(keyedBy: FriendCodingKeys.self)
    //        self.id = try first.decode(Int.self, forKey: .id)
    //        self.first_name = try first.decode(String.self, forKey: .first_name)
    //        self.last_name = try first.decode(String.self, forKey: .last_name)
    //        self.sex = try first.decode(Int.self, forKey: .sex)
    //        self.photo_50 = try first.decode(String.self, forKey: .photo_50)
    //        self.online = try first.decode(Int.self, forKey: .online)
    //
    //
    //    }
    
}

class VKDataresponse: Decodable {
    let count: Int = 0
    let items : [MyFrineds]
    
    enum CodingKeys: String, CodingKey {
        case items
        case count
        
    }
    
}

class VKFriendResponse: Decodable {
    let response: VKDataresponse
    
}



class FriendService
{
    static func loadAlllFriend (completion: @escaping ([MyFrineds]) -> Void)
    {
        //"nickname, sex, bdate , city",
        AF.request("https://api.vk.com/method/friends.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "user_id" : Session.instance.userId,
                    "order" : "name",
                    "fields" : "nickname,sex,bdate,photo_50",
                    "v" : "5.103"
        ]).responseData {
            response in
            guard let data = response.value else {return}
            do {
                
                let dataVKFriends =  try JSONDecoder().decode(VKFriendResponse.self, from: data).response.items
                completion(dataVKFriends)
            }
            catch {
                print(error)
            }
        }
        
    }
    
}
