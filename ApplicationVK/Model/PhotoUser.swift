//
//  PhotoUser.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 17.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

/*class VKPhotoSize: Decodable {
 let type: String
 let url: String
 
 enum CodingKeysPhotoSize: String, CodingKey {
 case type
 case url
 }
 
 }*/


final class VKPhoto: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var albumId: Int = 0
    @objc dynamic var ownerId: Int = 0
    //    let text: String
    //    let date: Int
    //    let sizes: [VKPhotoSize]
    @objc dynamic var url: String = ""
    //@objc dynamic var urlM: String = ""
    
    
    enum CodingKeysPhoto: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case sizes
    }
    
    enum CodingKeysPhotoSize: String, CodingKey {
        case type
        case url
    }
    
    
    
    convenience required init (from decoder: Decoder) throws {
        self.init()
        // try self.init(from: Decoder.self as! Decoder)
        //получаем контейнер массива фото
        let values = try decoder.container(keyedBy: CodingKeysPhoto.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.albumId = try values.decode(Int.self, forKey: .albumId)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        
        var photoSizeValues = try values.nestedUnkeyedContainer(forKey: .sizes)
        let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeysPhotoSize.self)
        self.url = try firstSizeValues.decode(String.self, forKey: .url)
//        while !photoSizeValues.isAtEnd {
//
//
//            let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeysPhotoSize.self)
//            let sizetype = try firstSizeValues.decode(String.self, forKey: .type)
//            switch sizetype {
//            case "x":
//                self.urlM = try firstSizeValues.decode(String.self, forKey: .url)
//            case "s":
//                self.url = try firstSizeValues.decode(String.self, forKey: .url)
//            default:
//                self.urlM = ""
//                self.url = ""
//            }
//
//
//        }
     
        

        
    }
    
    
}

class VKPhotosData: Decodable {
    let items: [VKPhoto]
    
    enum CodingKeysPhotoData: String, CodingKey {
        case items
    }
}

class VKPhotosResponse: Decodable {
    let response: VKPhotosData
}


class VKPhotosService {
    
    
    static func loadVKPhotoUser (userId: Int, completion: @escaping ([VKPhoto]) -> Void) {
        
        
        AF.request("https://api.vk.com/method/photos.getAll",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "owner_id" : userId,
                    "extended" : "0",
                    "count" : "10",
                    "no_service_albums" : "1",
                    "v" : "5.103"
        ]).responseData { response in
            guard let data = response.value else {return}
            do {
                let dataVKPhotoUser = try JSONDecoder().decode(VKPhotosResponse.self, from: data).response.items
                completion(dataVKPhotoUser)
                print ("фото")
                print(dataVKPhotoUser)
            }
            catch {
                print(error)
            }
            
        }
    }
    
}



