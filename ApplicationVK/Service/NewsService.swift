//
//  NewsService.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 24.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class NewsService
{
    static func loadAllNews ()
        //(completion: @escaping ([VKNews])-> Void)
    {
        // "filters" : "post,photo",
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post, photo",
                    "v" : "5.103"
        ]).responseData {
            response in
            guard let data = response.value else {return}
            do {
                
                let dataNews =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.items
                //completion(dataNews)
                print ("НОВОСТИ")
                print(dataNews.count)
                
                for index in 0...dataNews.count-1
                {
                    if let photoLost = dataNews[index].photos {
                       self.saveNewsPostPhoto(photoLost, postID: dataNews[index].postId)
                    }
                }
                saveNews (dataNews)
                
                
                let dataNewsProfiles = try JSONDecoder().decode(VKNewsRespons.self, from: data).response.profiles
                self.saveNewsPofiles(dataNewsProfiles)
                print ("профили пользователей")
                print (dataNewsProfiles.count)
                
                let dataNewsGroups =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.groups
                self.saveNewsGroups(dataNewsGroups)
                print ("ГРУППЫ ")
                print (dataNewsGroups.count)
                
                
            }
            catch{
                print(error)
            }
            
        }

    }
   
    //сохраняем полученные профили в реалм
    static func  saveNewsPofiles (_ profiles: [VKNewsProfile]) {
        do {
            let realm = try Realm()
            print("ссылка на профили !!!!!!!!!")
            print(realm.configuration.fileURL as Any)
            let oldProfiles = realm.objects(VKNewsProfile.self)
            realm.beginWrite()
            realm.delete(oldProfiles)
            realm.add(profiles)
            try realm.commitWrite()
        }
        catch
        {
            print (error)
        }
    }
    
    //сохранем полученные группы в реалм
    static func  saveNewsGroups (_ groups: [VKNewsGroup]) {
        do {
            let realm = try Realm()
            print("ссылка на группы!!!!!!! ")
            print(realm.configuration.fileURL as Any)
            let oldGroups = realm.objects(VKNewsGroup.self)
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
    
    
    //сохроняем новости
    static func  saveNews (_ newsList: [VKNews]) {
           do {
               let realm = try Realm()
               print("ссылка на новости !!!!!!! ")
               print(realm.configuration.fileURL as Any)
               let oldNews = realm.objects(VKNews.self)
               realm.beginWrite()
               realm.delete(oldNews)
               realm.add(newsList)
               try realm.commitWrite()
           }
           catch
           {
               print (error)
           }
       }
    
    
    //сохранем фото новостей реалм
    static func saveNewsPostPhoto (_ postPhotos: [VKNewsPhoto], postID: Int) {
        do {
            
            let realm = try Realm()
            print("ссылка на фото!!!!!!! ")
            print(realm.configuration.fileURL as Any)
            let strFilter = "postID == " + String(postID)
            let oldPostPhotos = realm.objects(VKNewsPhoto.self).filter(strFilter)
            realm.beginWrite()
            realm.delete(oldPostPhotos)
            realm.add(postPhotos)
            try realm.commitWrite()
        }
        catch
        {
            print (error)
        }
    }
    
}
