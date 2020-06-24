//
//  Friend.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift


class MyFrineds: Object, Decodable {
    @objc dynamic var  id: Int = 0
    @objc dynamic var  firstName: String = ""
    @objc dynamic var  lastLame: String = ""
    @objc dynamic var  sex: Int = 0
    @objc dynamic var  photo50: String = ""
    @objc dynamic var  online: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastLame = "last_name"
        case sex
        //        case bdate
        case photo50 = "photo_50"
        case online
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    convenience required init (from decoder: Decoder) throws {
//        self.init()
//         // try self.init(from: Decoder.self as! Decoder)
//         //получаем контейнер массива фото
//         let values = try decoder.container(keyedBy: FriendCodingKeys.self)
//
//         self.id = try values.decode(Int.self, forKey: .id)
//         self.firstName = try values.decode(String.self, forKey: .firstName)
//         self.lastLame = try values.decode(String.self, forKey: .lastLame)
//         self.sex = try values.decode(Int.self, forKey: .sex)
//         self.photo50 = try values.decode(String.self, forKey: .photo50)
//         self.online = try values.decode(Int.self, forKey: .online)
//
//     }
    
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
    static func loadAlllFriend ()
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
                self.saveFriends(dataVKFriends)
                
            }
            catch {
                print(error)
            }
        }
        
    }
    
   static func  saveFriends (_ friends: [MyFrineds]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL)
            let oldFriends = realm.objects(MyFrineds.self)
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends)
            try realm.commitWrite()
        }
        catch
        {
            print (error)
        }
    }
    
}
