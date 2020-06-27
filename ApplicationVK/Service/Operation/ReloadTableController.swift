//
//  ReloadTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 27.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ReloadTableController: Operation {
    var controller: MyGroupTableController
    //var token: NotificationToken?
    var vkGroups: Results<VKGroup>?
    
    init(controller: MyGroupTableController) {
        self.controller = controller
    }
    
    override func main() {
        
        guard let parseData = dependencies.first as? ParseDataVKGroup else { return }
        
        guard let realm = try? Realm() else {return}
        //получаем данные из реалм 
        vkGroups = realm.objects(VKGroup.self)
        controller.vkGroups = vkGroups
        controller.tableView.reloadData()
  
  }
}
