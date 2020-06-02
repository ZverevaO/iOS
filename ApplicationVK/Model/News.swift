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


//class VKNewsGroup: Decodable {
//    var id: Int = 0
//    var name: String = ""
//    var photo50: String = ""
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case photo50 = "photo_50"
//    }
//}
//
//class VKNewsProfile: Decodable {
//    var id: Int = 0
//    var firstName: String = ""
//    var lastName: String = ""
//    var photo50: String = ""
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case photo50 = "photo_50"
//    }
//}

//class Counts: Decodable {
//    var count: Int = 0
//}

class VKPhotoSize: Decodable {
    var type: String = ""
    var url: String = ""
    
}

class VKNewsPhoto: Decodable {
    var date: Int = 0
    var id: Int = 0
    var size: [VKPhotoSize] = []
}

class VKNewsPhotos: Decodable {
    var items: [VKNewsPhoto] = []
}

class VKNews: Decodable {
    
    var postId: Int = 0
    var sourceId: Int = 0
    var type: String = ""
    var date: Int = 0
    var text: String?
    var commentCount: Int?
    var likesCount: Int?
    var repostsCount: Int?
    var viewsCount: Int?
//    var comment: Counts?
//    var likes: Counts?
//    var reposts: Counts?
//    var views: Counts?
   
    //var photos: [VKNewsPhotos]?
    
    enum CodingKeyVKNews: String, CodingKey {
        case postId = "post_id"
        case sourceId = "source_id"
        case type
        case date
        case text
        case comments
        case likes
        case reposts
        case views
        case photos
    }
    
    
    enum CodingKeyCounts: String, CodingKey {
        case count
    }
    
    enum CodingKeyPhotos: String, CodingKey {
           case items
    }
    
    enum CodingKeyPhoto: String, CodingKey {
        case id
        case date
        case size
    }
    
    enum CodingKeySize: String, CodingKey {
        case url
        case type
    }
    
    required init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeyVKNews.self)
        
        self.postId = try values.decode(Int.self, forKey: .postId)
        self.sourceId = try values.decode(Int.self, forKey: .sourceId)
        let typeNews = try values.decode(String.self, forKey: .type)
        self.type = typeNews
        self.date = try values.decode(Int.self, forKey: .date)
        self.text = try? values.decode(String?.self, forKey: .text)
        
        if typeNews == "post" {
            let commentValue = try values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .comments)
            self.commentCount = try commentValue.decode(Int?.self, forKey: .count)
            
            let likesValue = try values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .likes)
            self.likesCount = try likesValue.decode(Int?.self, forKey: .count)
            
            let repostsValue = try values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .reposts)
            self.repostsCount = try repostsValue.decode(Int?.self, forKey: .count)
            
            let viewsValue = try values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .views)
            self.viewsCount = try viewsValue.decode(Int?.self, forKey: .count)

        }

        if typeNews == "photo" {
            print("фото")
         
        }
     
    }
}
//post,photo,photo_tag, wall_photo
class VKDataNews: Decodable {
    let items: [VKNews]
    //let profiles: [VKNewsProfile]
    //let groups: [VKNewsGroup]
    
  
}

class VKNewsRespons: Decodable {
    let response: VKDataNews
}


class NewsService
{
    static func loadAllNews ()
    {
        //"nickname, sex, bdate , city",
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post,photo",
                    "v" : "5.103"
        ]).responseData {
            response in
            guard let data = response.value else {return}
            do {
                
                let dataNews =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.items
                print ("НОВОСТИ")
                print(dataNews.count)
            }
            catch{
                print(error)
            }
            
        }
            
//            .responseJSON {
//            response in
//            print(response.value)
//        }
        
    }

    
}

