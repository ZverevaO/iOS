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
        let serviceDispatchGroup = DispatchGroup()
        
        // "filters" : "post,photo",
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post, photo",
                    "v" : "5.103"
        ]).responseData(queue: .global(qos: .utility)) {
            response in
            guard let data = response.value else {return}
            do {
                
                //запускаем парсинг в отдельных очередях
                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .utility) {
                    //парсим полученные новости
                    do {
                        let dataVKNews = try JSONDecoder().decode(VKNewsRespons.self, from: data).response
                     
                        saveNews(dataVKNews.items)
                        
                        for index in 0...dataVKNews.items.count-1
                        {
                            if let photoLost = dataVKNews.items[index].photos {
                                self.saveNewsPostPhoto(photoLost)
                            }
                            
                            // if let audiolist = dataVKNews.items[index].audios {
                            //self.saveNewsPostAudio(audiolist)
                            //}
                        }
                    }
                    catch {
                        print(error)
                    }
                }
                
                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .utility) {
                    do {
                        let dataNewsProfiles = try JSONDecoder().decode(VKNewsRespons.self, from: data).response.profiles
                        saveNewsPofiles(dataNewsProfiles)
                    }
                    catch {
                        print(error)
                    }
                }
                
                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .utility) {
                    do {
                        let dataNewsGroups =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.groups
                        saveNewsGroups(dataNewsGroups)
                    }
                    catch {
                        print (error)
                    }
                }
                
                serviceDispatchGroup.notify(queue: .global()) {  
                    print("сохранили все новости")
                    
                }
                
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
        catch {
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
        catch {
            print (error)
        }
    }
    
    
    //сохроняем новости
    static func  saveNews (_ newsList: [VKNews]) {
        do {
            let realm = try Realm()
            //let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //let realm = try Realm(configuration: config)
            //print(realm.configuration.fileURL as Any)
            // удаляем старые новости и фото для этих новостей
            let oldNews = realm.objects(VKNews.self)
            let oldPhoto = realm.objects(VKNewsPhoto.self)
            let oldAudio = realm.objects(VKNewsAudio.self)
            realm.beginWrite()
            realm.delete(oldNews)
            realm.delete(oldPhoto)
            realm.delete(oldAudio)
            realm.add(newsList)
            try realm.commitWrite()
        }
        catch {
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
        catch {
            print (error)
        }
    }
    
    //сохраняем аудио для новости
    static func saveNewsPostAudio (_ postAudios: [VKNewsAudio]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            realm.beginWrite()
            realm.add(postAudios)
            try realm.commitWrite()
        }
        catch {
            print (error)
        }
    }
}
