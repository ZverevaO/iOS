//
//  ParseDataVKGroup.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 27.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import RealmSwift

class ParseDataVKGroup: Operation {
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        
        //производим декодирование групп
        let dataVKGroups =  try? JSONDecoder().decode(VKGroupsResponse.self, from: data).response.items
        ParseDataVKGroup.self.saveGroups(dataVKGroups!)
    }
    
    //сохранение групп в реалм
    static func  saveGroups (_ groups: [VKGroup]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            let oldGroups = realm.objects(VKGroup.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            realm.add(groups)
            try realm.commitWrite()
        }
        catch
        {
            print (error)
        }
    }
}
