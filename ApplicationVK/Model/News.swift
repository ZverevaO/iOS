//
//  News.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//
import Foundation
import Alamofire


struct Comment {
    var nameUser: String
    var text: String
    var icon: String
}

class News {
    var nameAutor: String
    var textNews: String
    var newsFoto: [String] = []
    var countLike: Int
    var countView: Int
  //  var commentNews: [Comment] = []
    init (nameAutor: String, textNews: String, countLike: Int, countView: Int)
    {
        self.nameAutor = nameAutor
        self.textNews = textNews
//        self.newsFoto = newsFoto
        self.countLike = countLike
//        self.commentNews = commentNews
        self.countView = countView
    }
}



class NewsService
{
    static func loadAllNews ()
    {
        //"nickname, sex, bdate , city",
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "v" : "5.103"
        ]).responseJSON {
            response in
            print(response.value)
        }
        
    }

    
}

