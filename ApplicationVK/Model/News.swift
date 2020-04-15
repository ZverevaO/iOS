//
//  News.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

struct Comment {
    var nameUser: String
    var text: String
    var icon: String
}

class News {
    var nameAutor: String
    var textNews: String
//    var newsFoto: [String] = []
    var countLike: Int
    var countView: Int
//    var commentNews: [Comment] = []
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
