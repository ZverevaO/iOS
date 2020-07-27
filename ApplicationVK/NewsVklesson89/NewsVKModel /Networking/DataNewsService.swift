//
//  DataNewsService.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 26.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire

class DataNewsService {
    
    
    func loadPartDataNews (startFrom: String, comletion: @escaping (DataNews?, Error?, String?) -> Void) {
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post, photo",
                    "start_from": startFrom,
                    "v" : "5.103"
        ]).responseData(queue: .global(qos: .utility)) {
            
            respons in
            
            switch respons.result {
            case .success( let value):
                
                do { // если в блоке будет ошибка вернем ее в catch
                    var newsItem = [NewsItem]()
                    var users = [NewsProfile]()
                    var groups = [NewsGroup]()
                    var nextFrom = ""

                    
                    let decodeGroup = DispatchGroup()
                    
                    DispatchQueue.global().async(group: decodeGroup) {
                        do {
                            newsItem = try JSONDecoder().decode(NewsRespons.self, from: value).response.items
                        }
                        catch {
                            print (error)
                        }
                    }
                    
                    DispatchQueue.global().async(group: decodeGroup) {
                        do {
                            users = try JSONDecoder().decode(NewsRespons.self, from: value).response.profiles
                        }
                        catch {
                            print (error)
                        }
                    }
                    
                    DispatchQueue.global().async(group: decodeGroup) {
                        do {
                            groups = try JSONDecoder().decode(NewsRespons.self, from: value).response.groups
                        }
                        catch {
                            print (error)
                        }
                    }
                    
                    DispatchQueue.global().async(group: decodeGroup) {
                        do {
                            nextFrom = try JSONDecoder().decode(NewsRespons.self, from: value).response.nextFrom
                            Session.instance.nextFrom = nextFrom
                            
                        }
                        catch {
                            print (error)
                        }
                    }
                    
                    decodeGroup.notify(queue: DispatchQueue.main) {
                        let news = DataNews(items: newsItem, profiles: users, groups: groups, nextFrom: nextFrom)
                        comletion(news, nil, nextFrom)
                    }
                    
                }
                catch {
                    comletion(nil, error, nil)
                }
                
            case .failure(let error): do {
                comletion(nil, error, nil)
                }
            }
            
        }
        
    }
}
