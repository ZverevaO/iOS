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
    static func loadAllNews (startfrom: String)
        //(completion: @escaping ([VKNews])-> Void)
    {
        let serviceDispatchGroup = DispatchGroup()
        var vkNewsArray = [VKNews]()
        var vkProfileArray = [VKNewsProfile]()
        var vkGroupArray = [VKNewsGroup]()
        var vkNewsPhotoArray =  [Int: [VKNewsPhoto]]()
        // "filters" : "post,photo",
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post, photo",
                    "start_from": startfrom,
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

                        Session.instance.nextFrom = dataVKNews.nextFrom
                        vkNewsArray = dataVKNews.items

                        
                        for index in 0...dataVKNews.items.count-1
                        {
                            if let photoLost = dataVKNews.items[index].photos {
                                vkNewsPhotoArray[dataVKNews.items[index].postId] = photoLost
                            }
                        }
                    }
                    catch {
                        print(error)
                    }
                }
                
                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .utility) {
                    do {
                        let dataNewsProfiles = try JSONDecoder().decode(VKNewsRespons.self, from: data).response.profiles
                        vkProfileArray = dataNewsProfiles
                    }
                    catch {
                        print(error)
                    }
                }
                
                DispatchQueue.global().async(group: serviceDispatchGroup, qos: .utility) {
                    do {
                        let dataNewsGroups =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.groups
                        vkGroupArray = dataNewsGroups
                    }
                    catch {
                        print (error)
                    }
                }
                
                serviceDispatchGroup.notify(queue: .global()) {
                    saveNewsGroups(vkGroupArray,  needRemove: true)
                    saveNewsPofiles(vkProfileArray, needRemove: true)
                    saveNews(vkNewsArray,  needRemove: true)
                    for photo in vkNewsPhotoArray.values {
                        saveNewsPostPhoto(photo)
                    }
                    
                }
                
            }
            catch{
                print(error)
            }
            
        }
        
    }
    
    func loadPartVKNews (startfrom: String ,completion: @escaping (String?, Error?) -> Void) {
 
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post, photo",
                    "start_from": startfrom,
                    "v" : "5.103"
        ]).responseData(queue: .global(qos: .utility)) {
            response in
            switch response.result {
            case .success(let value):
                do {
                    var vkNewsArray = [VKNews]()
                    var vkProfileArray = [VKNewsProfile]()
                    var vkGroupArray = [VKNewsGroup]()
                    var vkNewsPhotoArray =  [Int: [VKNewsPhoto]]()
                    var nextFrom = ""
                    
                    let serviceDispatchGroup = DispatchGroup()
                    
                    let dataVKNews = try JSONDecoder().decode(VKNewsRespons.self, from: value).response
                   
                    vkNewsArray = dataVKNews.items
                    nextFrom = dataVKNews.nextFrom
                    Session.instance.nextFrom = nextFrom
                    for index in 0...dataVKNews.items.count-1
                    {
                        if let photoLost = dataVKNews.items[index].photos {
                            vkNewsPhotoArray[dataVKNews.items[index].postId] = photoLost
                        }
                    }
                    
                    let dataNewsGroups =  try JSONDecoder().decode(VKNewsRespons.self, from: value).response.groups
                    vkGroupArray = dataNewsGroups
                    let dataNewsProfiles = try JSONDecoder().decode(VKNewsRespons.self, from: value).response.profiles
                    vkProfileArray = dataNewsProfiles
                    
                    serviceDispatchGroup.notify(queue: DispatchQueue.main) {
                        completion(nextFrom, nil)
                    }
                    
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    //сохраняем полученные профили в реалм
    static func  saveNewsPofiles (_ profiles: [VKNewsProfile], needRemove: Bool) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            let oldProfiles = realm.objects(VKNewsProfile.self)
            realm.beginWrite()
            if needRemove {
                realm.delete(oldProfiles)
            }
            realm.add(profiles, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print (error)
        }
    }
    
    //сохранем полученные группы в реалм
    static func  saveNewsGroups (_ groups: [VKNewsGroup], needRemove: Bool) {
        do {
            let realm = try Realm()
            //print(realm.configuration.fileURL as Any)
            let oldGroups = realm.objects(VKNewsGroup.self)
            realm.beginWrite()
            if needRemove {
                realm.delete(oldGroups)
            }
            realm.add(groups, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print (error)
        }
    }
    
    
    //сохроняем новости
    static func  saveNews (_ newsList: [VKNews], needRemove: Bool) {
        do {
            let realm = try Realm()
            //let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //let realm = try Realm(configuration: config)
            //print(realm.configuration.fileURL as Any)
            // удаляем старые новости и фото для этих новостей
            let oldNews = realm.objects(VKNews.self)
            let oldPhoto = realm.objects(VKNewsPhoto.self)
            //let oldAudio = realm.objects(VKNewsAudio.self)
            realm.beginWrite()
            if needRemove {
                realm.delete(oldNews)
                realm.delete(oldPhoto)
                //realm.delete(oldAudio)
            }
            realm.add(newsList, update: .modified)
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
            //let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //let realm = try Realm(configuration: config)
            //print(realm.configuration.fileURL as Any)
            //let strFilter = "postID == " + String(postID)
            //let oldPostPhotos = realm.objects(VKNewsPhoto.self).filter(strFilter)
            realm.beginWrite()
            //realm.delete(oldPostPhotos)
            //realm.add(postPhotos)
            realm.add(postPhotos, update: .modified)
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
            realm.add(postAudios, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print (error)
        }
    }
}
