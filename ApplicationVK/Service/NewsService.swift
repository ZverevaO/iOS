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
                
                self.saveNews(dataNews)
                
                for index in 0...dataNews.count-1
                {
                    if let photoLost = dataNews[index].photos {
                        self.saveNewsPostPhoto(photoLost)
                    }
                }
                
                let dataNewsProfiles = try JSONDecoder().decode(VKNewsRespons.self, from: data).response.profiles
                self.saveNewsPofiles(dataNewsProfiles)
                
                let dataNewsGroups =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.groups
                self.saveNewsGroups(dataNewsGroups)
                
                //let serviceDispatchGroup = DispatchGroup()
                
                //
                //                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .background)
                //                {
                //                    let dataNews =  try? JSONDecoder().decode(VKNewsRespons.self, from: data).response.items
                //
                //                    self.saveNews(dataNews!)
                //
                //                    for index in 0...dataNews!.count-1
                //                    {
                //                        if let photoLost = dataNews![index].photos {
                //                            self.saveNewsPostPhoto(photoLost, postID: dataNews![index].postId)
                //                        }
                //                    }
                //                    print("очередь декодирования новостей")
                //
                //                }
                
                //                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .background)
                //                {
                //                    let dataNewsProfiles = try? JSONDecoder().decode(VKNewsRespons.self, from: data).response.profiles
                //                    self.saveNewsPofiles(dataNewsProfiles!)
                //                    print("очередь декодирования профилей")
                //                }
                
                //                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .background)
                //                {
                //                    let dataNewsGroups =  try? JSONDecoder().decode(VKNewsRespons.self, from: data).response.groups
                //                    self.saveNewsGroups(dataNewsGroups!)
                //                    print("очередь декодирования групп")
                //                }
                //
                //
                //
                //                serviceDispatchGroup.notify(queue: .global()) {
                //                    print("сохранили все новости")
                //                }
                //
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
            //print(realm.configuration.fileURL as Any)
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
            //print(realm.configuration.fileURL as Any)
            // удаляем старые новости и фото для этих новостей
            let oldNews = realm.objects(VKNews.self)
            let oldPhoto = realm.objects(VKNewsPhoto.self)
            realm.beginWrite()
            realm.delete(oldNews)
            realm.delete(oldPhoto)
            realm.add(newsList)
            try realm.commitWrite()
        }
        catch
        {
            print (error)
        }
    }
    
    
    //сохранем фото новостей реалм
    static func saveNewsPostPhoto (_ postPhotos: [VKNewsPhoto]) {
        do {
            
            let realm = try Realm()
            //print(realm.configuration.fileURL as Any)
            //let strFilter = "postID == " + String(postID)
            //let oldPostPhotos = realm.objects(VKNewsPhoto.self).filter(strFilter)
            realm.beginWrite()
            //realm.delete(oldPostPhotos)
            realm.add(postPhotos)
            try realm.commitWrite()
        }
        catch
        {
            print (error)
        }
    }
    
}
