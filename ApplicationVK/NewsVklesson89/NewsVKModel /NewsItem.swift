//
//  NewsItem.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 26.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import UIKit

class NewsItem: Decodable {
    
    var postId: Int = 0
    var sourceId: Int = 0
    var type: String = ""
    var date: Double = 0
    var text: String = ""
    var commentCount: Int = -1
    var likesCount: Int = -1
    var repostsCount: Int = -1
    var viewsCount: Int = -1

    var photos: [NewsPhotos] = []
    var countPhoto: Int = -1
    

    
    
    
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
        case audio
    }
    
    enum CodingKeySize: String, CodingKey {
        case url
        case type
        case width
        case height
    }
    
    required init  (from decoder: Decoder) throws {
        
        //массив для хранения фото
        var photosNews: [NewsPhotos] = []
        
        var id: Int = 0
        var date: Int = 0
        var url = ""
        var urlX = ""
        var height: Int = 0
        var width: Int = 0
        
        let values = try decoder.container(keyedBy: CodingKeyVKNews.self)
        let postId = try values.decode(Int.self, forKey: .postId)
        self.postId = postId //try values.decode(Int.self, forKey: .postId)
        //let post = try values.decode(Int.self, forKey: .postId)
        self.sourceId = try values.decode(Int.self, forKey: .sourceId)
        let typeNews = try values.decode(String.self, forKey: .type)
        self.type = typeNews
        self.date = try values.decode(Double.self, forKey: .date)
        let text =  try? values.decode(String?.self, forKey: .text)
        self.text =  text ?? "" //try? values.decode(String?.self, forKey: .text)
        
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
                                width = try firstSizeAttachment.decode(Int.self, forKey: .width)
                                height = try firstSizeAttachment.decode(Int.self, forKey: .height)
                            case "m":
                                url = try firstSizeAttachment.decode(String.self, forKey: .url)
                            default:
                                break
                            }
                        }
                        let photoAtt = NewsPhotos (date: date, id: id, url: url, urlX: urlX, postID: postId, width: width, height: height )
                        photos.append(photoAtt)
                        self.photos = photosNews
                        //self.countPhoto = photosNews?.count ?? (-1)
                        //завершили обработку фото
                        }
                    case "video":
                        print("тип вложения \(attachmetnType)")
                    case "audio": do {
                        //обработка вложения audio
                        print("тип вложения \(attachmetnType)")
                        
                        //завершили обработку вложения audio
                        }
                    default:
                        print("неизвестынй тип вложения \(attachmetnType)")
                    }
                }
                //self.countPhoto = photosNews.count
                
            }
            else
            {
                print("ничего нет ")
            }
            
            
            if let commentValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .comments) {
                self.commentCount = try commentValue.decode(Int.self, forKey: .count)
            }
            
            if let likesValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .likes) {
                self.likesCount = try likesValue.decode(Int.self, forKey: .count)
            }
            
            if let repostsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .reposts) {
                self.repostsCount = try repostsValue.decode(Int.self, forKey: .count)
            }
            
            if let viewsValue = try? values.nestedContainer(keyedBy: CodingKeyCounts.self, forKey: .views) {
                self.viewsCount = try viewsValue.decode(Int.self, forKey: .count)
            }
            //конец  обработки новости с типом post
            }
            
        case "photo": do {
            //начало обработки фото
            let photosValue =  try values.nestedContainer(keyedBy: CodingKeyVKNews.self, forKey: .photos)
            var photoList  = try photosValue.nestedUnkeyedContainer(forKey: .items)
            while !photoList.isAtEnd {
                let photoInf = try photoList.nestedContainer(keyedBy: CodingKeyPhoto.self)
                id = try photoInf.decode(Int.self, forKey: .id)
                date = try photoInf.decode(Int.self, forKey: .date)
                url = ""
                urlX = ""
                width = 0
                height = 0
                var photoSizeValues = try photoInf.nestedUnkeyedContainer(forKey: .sizes)
                
                while !photoSizeValues.isAtEnd {
                    
                    let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeySize.self)
                    let sizetype = try firstSizeValues.decode(String.self, forKey: .type)
                    switch sizetype {
                    case "x":
                        urlX = try firstSizeValues.decode(String.self, forKey: .url)
                        width = try firstSizeValues.decode(Int.self, forKey: .width)
                        height = try firstSizeValues.decode(Int.self, forKey: .height)
                    case "m":
                        url = try firstSizeValues.decode(String.self, forKey: .url)
                    default:
                        break
                    }
                }
                
                let photo = NewsPhotos(date: date, id: id, url: url, urlX: urlX, postID: postId,  width: width, height: height)
                photosNews.append(photo)
            }
            self.photos = photosNews
            self.countPhoto = photosNews.count

            }
        default:
            print ("неопознанный тип новости")
        }
    }
   
}
