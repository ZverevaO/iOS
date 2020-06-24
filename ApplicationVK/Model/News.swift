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

class VKNewsPhoto  {
    var date: Int
    var id: Int
    var url: String
    var urlX: String
    
    init (date: Int, id: Int, url: String, urlX: String)
    {
        self.date = date
        self.id = id
        self.url = url
        self.urlX = urlX
    }
    
    //    enum CodingKeyPhoto: String, CodingKey {
    //        case sizes
    //        case type
    //        case url
    //        case date
    //        case id
    //    }
    //
    
    //    required init (from decoder: Decoder) throws {
    //        let values = try decoder.container(keyedBy: CodingKeyPhoto.self)
    //        self.id = try values.decode(Int.self, forKey: .id)
    //        self.date = try values.decode(Int.self, forKey: .date)
    //
    //        var photoSizeValues = try values.nestedUnkeyedContainer(forKey: .sizes)
    //        while !photoSizeValues.isAtEnd {
    //            let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeyPhoto.self)
    //            let sizetype = try firstSizeValues.decode(String.self, forKey: .type)
    //            switch sizetype {
    //            case "x":
    //                self.urlX = try firstSizeValues.decode(String.self, forKey: .url)
    //            case "m":
    //                self.url = try firstSizeValues.decode(String.self, forKey: .url)
    //            default:
    //                break
    //            }
    //        }
    //
    //    }
    
}

//class VKNewsPhotos:  {
//    var items: [VKNewsPhoto] = []
//}

var count: Int = 0
class VKNews: Decodable {
    
    var postId: Int = 0
    var sourceId: Int = 0
    var type: String = ""
    var date: Double = 0
    var text: String?
    var commentCount: Int?
    var likesCount: Int?
    var repostsCount: Int?
    var viewsCount: Int?
    //    var comment: Counts?
    //    var likes: Counts?
    //    var reposts: Counts?
    //    var views: Counts?
    
    var photos: [VKNewsPhoto]?
    
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
    
    //    enum CodingKeyPhotos: String, CodingKey {
    //           case items
    //           case size
    //    }
    
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
    
    required init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeyVKNews.self)
        
        self.postId = try values.decode(Int.self, forKey: .postId)
        let post = try values.decode(Int.self, forKey: .postId)
        self.sourceId = try values.decode(Int.self, forKey: .sourceId)
        let typeNews = try values.decode(String.self, forKey: .type)
        self.type = typeNews
        self.date = try values.decode(Double.self, forKey: .date)
        self.text = try? values.decode(String?.self, forKey: .text)
        let text =  try? values.decode(String?.self, forKey: .text)
        var photosNews: [VKNewsPhoto]? = []
        var id: Int = 0
        var date: Int = 0
        var url = ""
        var urlX = ""
        
       
        if typeNews == "post" {
            
            let attachmentsVal = try? values.nestedUnkeyedContainer(forKey: .attachments)
            if (attachmentsVal == nil)  {
                print("ид новости " + String(post))
                print(text)
                print(typeNews)
            }
            else
            {
                
                var attachmentsValue = try values.nestedUnkeyedContainer(forKey: .attachments)
                while !attachmentsValue.isAtEnd {
                    let attachmentItems = try  attachmentsValue.nestedContainer(keyedBy: CodingKeyAttachment.self)
                    let attachmetnType = try attachmentItems.decode(String.self, forKey: .type)
                    print ("тип вложения " + (attachmetnType))
                    if attachmetnType == "photo" {
                        print ("это фото парсим дальше " + (attachmetnType) + String(count))
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
                        let photoAtt = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX)
                        photosNews?.append(photoAtt)
                        self.photos = photosNews
                        print (photosNews?.count)
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
                
                let photo = VKNewsPhoto(date: date, id: id, url: url, urlX: urlX)
                photosNews?.append(photo)
            }
            self.photos = photosNews
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
    static func loadAllNews (completion: @escaping ([VKNews])-> Void)
    {
        // "filters" : "post,photo",
        AF.request("https://api.vk.com/method/newsfeed.get",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "filters" : "post",
                    "v" : "5.103"
        ]).responseData {
            response in
            guard let data = response.value else {return}
            do {
                
                let dataNews =  try JSONDecoder().decode(VKNewsRespons.self, from: data).response.items
                completion(dataNews)
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

