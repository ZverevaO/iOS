//
//  Group.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class VKGroup: Object, Decodable, Comparable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var membersCount: Int = 0
    @objc dynamic var photo50: String = ""
    
    enum CodingKeys: String, CodingKey {
           case id
           case name
           case screenName = "screen_name"
           case membersCount = "members_count"
           case photo50 = "photo_50"
           
       }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func == (lhs: VKGroup, rhs: VKGroup) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: VKGroup, rhs: VKGroup) -> Bool {
        return lhs.name < rhs.name
    }
    
    
//    convenience required init (from decoder: Decoder) throws {
//       self.init()
//        // try self.init(from: Decoder.self as! Decoder)
//        //получаем контейнер массива фото
//        let values = try decoder.container(keyedBy: GroupCodingKeys.self)
//
//        self.id = try values.decode(Int.self, forKey: .id)
//        self.name = try values.decode(String.self, forKey: .name)
//        self.screenName = try values.decode(String.self, forKey: .screenName)
//        self.membersCount = try values.decode(Int.self, forKey: .membersCount)
//        self.photo50 = try values.decode(String.self, forKey: .photo50)
//
//    }
//    
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
    static func loadGroupsUser (completion: @escaping () -> Void)
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
                self.saveGroups(dataVKGroups)
                completion()
                print(response.value)
            }
            catch{
                print(error)
            }
            
        }
    }
    
    static func  saveGroups (_ groups: [VKGroup]) {
           do {
               let realm = try Realm()
               print(realm.configuration.fileURL)
               let oldGroups = realm.objects(VKGroup.self)
               realm.beginWrite()
               realm.delete(oldGroups)
               realm.add(groups)
               try realm.commitWrite()
           }
           catch
           {
               print (error)
           }
       }
}


