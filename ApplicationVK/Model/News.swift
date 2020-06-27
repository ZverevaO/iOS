//
//  News.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//
import Foundation
import Alamofire
import RealmSwift


// источник новостей группы
class VKNewsGroup: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo50: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo50 = "photo_50"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

//источник новостей юзеры
class VKNewsProfile: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic  var photo50: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}



class VKPhotoSize: Decodable {
    var type: String = ""
    var url: String = ""
    
}

//класс для хранения фотографий 
class VKNewsPhoto: Object  {
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var urlX: String = ""
    @objc dynamic var postID: Int = 0
    
    
    convenience required init (date: Int, id: Int, url: String, urlX: String, postID: Int)
    {
        self.init()
        self.date = date
        self.id = id
        self.url = url
        self.urlX = urlX
        self.postID = postID
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}


class VKNews: Object, Decodable {
    
    @objc dynamic var postId: Int = 0
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var date: Double = 0
    @objc dynamic var text: String = ""
    var commentCount: Int?
    var likesCount: Int?
    var repostsCount: Int?
    var viewsCount: Int?
    var photos: [VKNewsPhoto]?
    @objc dynamic var countPhoto: Int = -1
    
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
        case items
        case size
        case attachments
    }
    
    
    enum CodingKeyCounts: String, CodingKey {
        case count
    }
    
    
    enum CodingKeyPhoto: String, CodingKey {
        case id
        case date
        case sizes
    }
    
    enum CodingKeyAttachment: String, CodingKey {
        case type
        case photo
    }
    
    enum CodingKeySize: String, CodingKey {
        case url
        case type
    }
    
    convenience required init  (from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeyVKNews.self)
        let postId = try values.decode(Int.self, forKey: .postId)
        self.postId = postId //try values.decode(Int.self, forKey: .postId)
        //let post = try values.decode(Int.self, forKey: .postId)
        self.sourceId = try values.decode(Int.self, forKey: .sourceId)
        let typeNews = try values.decode(String.self, forKey: .type)
        self.type = typeNews
        self.date = try values.decode(Double.self, forKey: .date)
        let text =  try? values.decode(String?.self, forKey: .text)
        self.text =  text ?? " " //try? values.decode(String?.self, forKey: .text)
        
        var photosNews: [VKNewsPhoto]? = []
        var id: Int = 0
        var date: Int = 0
        var url = ""
        var urlX = ""
        
        switch typeNews {
        case "post": do {
            //начало обработки новости с типом post
            if var  attachmentsValue = try? values.nestedUnkeyedContainer(forKey: .attachments)
            {
                
                while !attachmentsValue.isAtEnd {
                    let attachmentItems = try  attachmentsValue.nestedContainer(keyedBy: CodingKeyAttachment.self)
                    let attachmetnType = try attachmentItems.decode(String.self, forKey: .type)
                    
                    switch attachmetnType {
                    case "photo": do {
                        //обработка вложений типа фото
                        // print ("это фото парсим дальше " + (attachmetnType) + String(count))
                        let photoAttachment = try attachmentItems.nestedContainer(keyedBy: CodingKeyPhoto.self, forKey: .photo)
                        id = try photoAttachment.decode(Int.self, forKey: .id)
                        date = try photoAttachment.decode(Int.self, forKey: .date)
                        var photoSizeAttachment = try photoAttachment.nestedUnkeyedContainer(forKey: .sizes)
                        while !photoSizeAttachment.isAtEnd {
                            
                            let firstSizeAttachment = try photoSizeAttachment.nestedContainer(keyedBy: CodingKeySize.self)
                            let sizeTypeAttachment = try firstSizeAttachment.decode(String.self, forKey: .type)
                            switch sizeTypeAttachment {
                            case "x":
                                urlX = try firstSizeAttachment.decode(String.self, forKey: .url)
                            case "m":
                                url = try firstSizeAttachment.decode(String.self, forKey: .url)
                            default:
                                break
                            }
                            
                            
                        }
                        let photoAtt = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX, postID: postId)
                        photosNews?.append(photoAtt)
                        self.photos = photosNews
                        self.countPhoto = photosNews?.count ?? (-1)
                        //завершили обработку фото
                        }
                    case "video":
                        print("тип вложения \(attachmetnType)")
                    case "audio":
                        print("тип вложения \(attachmetnType)")
                    default:
                        print("неизвестынй тип вложения \(attachmetnType)")
                    }
                    
                    
                    let commentValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .comments)
                    self.commentCount = try commentValue?.decode(Int?.self, forKey: .count)
                    
                    let likesValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .likes)
                    self.likesCount = try likesValue?.decode(Int?.self, forKey: .count)
                    
                    let repostsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .reposts)
                    self.repostsCount = try repostsValue?.decode(Int?.self, forKey: .count)
                    
                    let viewsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .views)
                    self.viewsCount = try viewsValue?.decode(Int?.self, forKey: .count)
                    
                }
            }
            else
            {
                print("ничего нет ")
            }
            //конец  обработки новости с типом post
            }
            
        case "photo": do {
            //начало обработки фото
            let photosValue =  try values.nestedContainer(keyedBy: CodingKeyVKNews.self, forKey: .photos)
            var photoList  = try photosValue.nestedUnkeyedContainer(forKey: .items)
            //var photosNews: [VKNewsPhoto]? = []
            while !photoList.isAtEnd {
                let photoInf = try photoList.nestedContainer(keyedBy: CodingKeyPhoto.self)
                id = try photoInf.decode(Int.self, forKey: .id)
                date = try photoInf.decode(Int.self, forKey: .date)
                url = ""
                urlX = ""
                var photoSizeValues = try photoInf.nestedUnkeyedContainer(forKey: .sizes)
                
                while !photoSizeValues.isAtEnd {
                    
                    let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeySize.self)
                    let sizetype = try firstSizeValues.decode(String.self, forKey: .type)
                    switch sizetype {
                    case "x":
                        urlX = try firstSizeValues.decode(String.self, forKey: .url)
                    case "m":
                        url = try firstSizeValues.decode(String.self, forKey: .url)
                    default:
                        break
                    }
                }
                
                let photo = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX, postID: postId)
                photosNews?.append(photo)
            }
            self.photos = photosNews
            self.countPhoto = photosNews?.count ?? -1
            //конец обработки типа фото
            }
        default:
            print ("неопознанный тип новости")
        }
        
    }
}
//post,photo,photo_tag, wall_photo
class VKDataNews: Decodable {
    let items: [VKNews]
    let profiles: [VKNewsProfile]
    var groups: [VKNewsGroup]
    
    enum CodingKeys: String, CodingKey {
           case items
           case profiles
           case groups
       }
    
    required init (from decoder: Decoder)  throws
    {
     

        let dataNews = try decoder.container(keyedBy: CodingKeys.self)
        
//        try DispatchQueue.global().async() { [weak self] in
//            self?.groups = try dataNews.decode([VKNewsGroup].self, forKey: .groups)
//        }
//        DispatchQueue.global().async() {
//            self.profiles = try dataNews.decode([VKNewsProfile].self, forKey: .profiles)
//        }
//        DispatchQueue.global().async() {
//            self.items = try dataNews.decode([VKNews].self, forKey: .items)
//        }
        self.groups = try dataNews.decode([VKNewsGroup].self, forKey: .groups)
        self.profiles = try dataNews.decode([VKNewsProfile].self, forKey: .profiles)
        self.items = try dataNews.decode([VKNews].self, forKey: .items)
    
    }
       
}

class VKNewsRespons: Decodable {
    let response: VKDataNews
}



//старый инициализиатор
/*    convenience required init  (from decoder: Decoder) throws {
 self.init()
 
 let values = try decoder.container(keyedBy: CodingKeyVKNews.self)
 let postId = try values.decode(Int.self, forKey: .postId)
 self.postId = postId //try values.decode(Int.self, forKey: .postId)
 let post = try values.decode(Int.self, forKey: .postId)
 self.sourceId = try values.decode(Int.self, forKey: .sourceId)
 let typeNews = try values.decode(String.self, forKey: .type)
 self.type = typeNews
 self.date = try values.decode(Double.self, forKey: .date)
 let text =  try? values.decode(String?.self, forKey: .text)
 self.text =  text ?? " " //try? values.decode(String?.self, forKey: .text)
 
 var photosNews: [VKNewsPhoto]? = []
 var id: Int = 0
 var date: Int = 0
 var url = ""
 var urlX = ""
 
 if typeNews == "post" {
 
 
 
 if var  attachmentsValue = try? values.nestedUnkeyedContainer(forKey: .attachments)
 {
 
 while !attachmentsValue.isAtEnd {
 let attachmentItems = try  attachmentsValue.nestedContainer(keyedBy: CodingKeyAttachment.self)
 let attachmetnType = try attachmentItems.decode(String.self, forKey: .type)
 // print ("тип вложения " + (attachmetnType))
 if attachmetnType == "photo" {
 // print ("это фото парсим дальше " + (attachmetnType) + String(count))
 let photoAttachment = try attachmentItems.nestedContainer(keyedBy: CodingKeyPhoto.self, forKey: .photo)
 id = try photoAttachment.decode(Int.self, forKey: .id)
 date = try photoAttachment.decode(Int.self, forKey: .date)
 var photoSizeAttachment = try photoAttachment.nestedUnkeyedContainer(forKey: .sizes)
 while !photoSizeAttachment.isAtEnd {
 
 let firstSizeAttachment = try photoSizeAttachment.nestedContainer(keyedBy: CodingKeySize.self)
 let sizeTypeAttachment = try firstSizeAttachment.decode(String.self, forKey: .type)
 switch sizeTypeAttachment {
 case "x":
 urlX = try firstSizeAttachment.decode(String.self, forKey: .url)
 case "m":
 url = try firstSizeAttachment.decode(String.self, forKey: .url)
 default:
 break
 }
 
 
 }
 let photoAtt = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX, postID: postId)
 photosNews?.append(photoAtt)
 self.photos = photosNews
 self.countPhoto = photosNews?.count ?? (-1)
 } else {
 self.countPhoto = (-1)
 }
 
 
 let commentValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .comments)
 self.commentCount = try commentValue?.decode(Int?.self, forKey: .count)
 
 let likesValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .likes)
 self.likesCount = try likesValue?.decode(Int?.self, forKey: .count)
 
 let repostsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .reposts)
 self.repostsCount = try repostsValue?.decode(Int?.self, forKey: .count)
 
 let viewsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .views)
 self.viewsCount = try viewsValue?.decode(Int?.self, forKey: .count)
 
 }
 }
 else
 {
 print("ничего нет ")
 }
 
 let attachmentsVal = try? values.nestedUnkeyedContainer(forKey: .attachments)
 
 if (attachmentsVal == nil)  {
 //print("ид новости " + String(post))
 //print(text)
 //print(typeNews)
 }
 else
 {
 
 var attachmentsValue = try values.nestedUnkeyedContainer(forKey: .attachments)
 while !attachmentsValue.isAtEnd {
 let attachmentItems = try  attachmentsValue.nestedContainer(keyedBy: CodingKeyAttachment.self)
 let attachmetnType = try attachmentItems.decode(String.self, forKey: .type)
 // print ("тип вложения " + (attachmetnType))
 if attachmetnType == "photo" {
 // print ("это фото парсим дальше " + (attachmetnType) + String(count))
 let photoAttachment = try attachmentItems.nestedContainer(keyedBy: CodingKeyPhoto.self, forKey: .photo)
 id = try photoAttachment.decode(Int.self, forKey: .id)
 date = try photoAttachment.decode(Int.self, forKey: .date)
 var photoSizeAttachment = try photoAttachment.nestedUnkeyedContainer(forKey: .sizes)
 while !photoSizeAttachment.isAtEnd {
 
 let firstSizeAttachment = try photoSizeAttachment.nestedContainer(keyedBy: CodingKeySize.self)
 let sizeTypeAttachment = try firstSizeAttachment.decode(String.self, forKey: .type)
 switch sizeTypeAttachment {
 case "x":
 urlX = try firstSizeAttachment.decode(String.self, forKey: .url)
 case "m":
 url = try firstSizeAttachment.decode(String.self, forKey: .url)
 default:
 break
 }
 
 
 }
 let photoAtt = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX, postID: postId)
 photosNews?.append(photoAtt)
 self.photos = photosNews
 self.countPhoto = photosNews?.count ?? (-1)
 } else {
 self.countPhoto = (-1)
 }
 
 
 let commentValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .comments)
 self.commentCount = try commentValue?.decode(Int?.self, forKey: .count)
 
 let likesValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .likes)
 self.likesCount = try likesValue?.decode(Int?.self, forKey: .count)
 
 let repostsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .reposts)
 self.repostsCount = try repostsValue?.decode(Int?.self, forKey: .count)
 
 let viewsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .views)
 self.viewsCount = try viewsValue?.decode(Int?.self, forKey: .count)
 
 }
 }
 
 
 
 }
 
 if typeNews == "photo" {
 let photosValue =  try values.nestedContainer(keyedBy: CodingKeyVKNews.self, forKey: .photos)
 var photoList  = try photosValue.nestedUnkeyedContainer(forKey: .items)
 //var photosNews: [VKNewsPhoto]? = []
 while !photoList.isAtEnd {
 let photoInf = try photoList.nestedContainer(keyedBy: CodingKeyPhoto.self)
 id = try photoInf.decode(Int.self, forKey: .id)
 date = try photoInf.decode(Int.self, forKey: .date)
 url = ""
 urlX = ""
 var photoSizeValues = try photoInf.nestedUnkeyedContainer(forKey: .sizes)
 
 while !photoSizeValues.isAtEnd {
 
 let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeySize.self)
 let sizetype = try firstSizeValues.decode(String.self, forKey: .type)
 switch sizetype {
 case "x":
 urlX = try firstSizeValues.decode(String.self, forKey: .url)
 case "m":
 url = try firstSizeValues.decode(String.self, forKey: .url)
 default:
 break
 }
 }
 
 let photo = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX, postID: postId)
 photosNews?.append(photo)
 }
 self.photos = photosNews
 self.countPhoto = photosNews?.count ?? -1
 }
 
 } */

