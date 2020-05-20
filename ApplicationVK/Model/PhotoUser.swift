//
//  PhotoUser.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 17.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire

/*class VKPhotoSize: Decodable {
    let type: String
    let url: String
    
    enum CodingKeysPhotoSize: String, CodingKey {
        case type
        case url
    }

}*/


final class VKPhoto: Decodable {
    let id: Int
    let album_id: Int
    let owner_id: Int
//    let text: String
//    let date: Int
//    let sizes: [VKPhotoSize]
     let url: String
    
    enum CodingKeysPhoto: String, CodingKey {
        case id
        case album_id
        case owner_id
        case sizes
    }
    
    enum CodingKeysPhotoSize: String, CodingKey {
           case type
           case url
       }
    
  
    
    init (from decoder: Decoder) throws {
        // try self.init(from: Decoder.self as! Decoder)
        //получаем контейнер массива фото
        let values = try decoder.container(keyedBy: CodingKeysPhoto.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.album_id = try values.decode(Int.self, forKey: .album_id)
        self.owner_id = try values.decode(Int.self, forKey: .owner_id)
        
        var photoSizeValues = try values.nestedUnkeyedContainer(forKey: .sizes)
        let firstSizeValues = try photoSizeValues.nestedContainer(keyedBy: CodingKeysPhotoSize.self)
        self.url = try firstSizeValues.decode(String.self, forKey: .url)
        
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



