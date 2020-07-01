//
//  FriendService.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import PromiseKit

class FriendService
{
    static func freandPromise () -> Promise<[MyFrineds]> {
        let friendRequest = AF.request("https://api.vk.com/method/friends.get",
                                       parameters: [
                                        "access_token" : Session.instance.token,
                                        "user_id" : Session.instance.userId,
                                        "order" : "name",
                                        "fields" : "nickname,sex,bdate,photo_50",
                                        "v" : "5.103"
        ])
        
        return Promise { resolver in
            friendRequest.responseData {
                respons in
                switch respons.result {
                case .success(let value): do {
                    do {
                        let dataVKFriends =  try JSONDecoder().decode(VKFriendResponse.self, from: value).response.items
                        self.saveFriends(dataVKFriends)
                    }
                    catch {
                        print(error)
                    }
                    }
                case .failure(let error): resolver.reject(error)
                }
            }
        }
    }
    
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
            print(realm.configuration.fileURL as Any)
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

