//
//  MyGroupsService.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 27.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class VKGroupsService {
    
    static func loadGroupsUser (controller: MyGroupTableController) {
        let request = AF.request("https://api.vk.com/method/groups.get",
                                 parameters: [
                                    "access_token" : Session.instance.token,
                                    "user_id" : Session.instance.userId,
                                    "extended" : "1",
                                    "fields" : "description,members_count",
                                    "v" : "5.103"
        ])
        
        //создаем очередь
        let queue = OperationQueue()
        
        //задача на выполнение запроса
        let getDataOperation = GetDataOperation(request: request)
        queue.addOperation(getDataOperation)
        
        //задача на парсинг даных
        let parseDataVKGroup = ParseDataVKGroup()
        //добавляем зависимость
        parseDataVKGroup.addDependency(getDataOperation)
        queue.addOperation(parseDataVKGroup)
        
        //задание на обновление контроллера
        let realoadGroupController = ReloadTableController(controller: controller)
        
        //добавляем зависимость
        realoadGroupController.addDependency(parseDataVKGroup)
        
        //добавляем на глвную очередь
        OperationQueue.main.addOperation(realoadGroupController)
        
    }
    
}



//старый вариант функции
//class VKGroupsService
//{
//    static func loadGroupsUser ()
//    {
//        AF.request("https://api.vk.com/method/groups.get",
//                   parameters: [
//                    "access_token" : Session.instance.token,
//                    "user_id" : Session.instance.userId,
//                    "extended" : "1",
//                    "fields" : "description,members_count",
//                    "v" : "5.103"
//        ]).responseData {
//            response in
//            guard let data = response.value else {return}
//            do {
//
//                let dataVKGroups =  try JSONDecoder().decode(VKGroupsResponse.self, from: data).response.items
//                self.saveGroups(dataVKGroups)
//                print(response.value as Any)
//            }
//            catch{
//                print(error)
//            }
//
//        }
//    }
//
//    static func  saveGroups (_ groups: [VKGroup]) {
//           do {
//               let realm = try Realm()
//            print(realm.configuration.fileURL as Any)
//               let oldGroups = realm.objects(VKGroup.self)
//               realm.beginWrite()
//               realm.delete(oldGroups)
//               realm.add(groups)
//               try realm.commitWrite()
//           }
//           catch
//           {
//               print (error)
//           }
//       }
//}


