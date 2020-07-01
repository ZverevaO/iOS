//
//  MyGroupTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift
//import FirebaseDatabase


class MyGroupTableController: UITableViewController {
    
    var myGroup: [VKGroup] = [] //GroupDB.getGroups()
    var allMyGroups: [VKGroup] = []
    var token: NotificationToken?
    var vkGroups: Results<VKGroup>?

//    private var userGroups = [FireBaseUserGroups]()
//    private let ref = Database.database().reference(withPath: "userGroups")
    
    
    @IBOutlet weak var groupSearch: UISearchBar!
    
    
    var controlRrefresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAdnRealm()
        
        groupSearch.delegate = self
        
       // loadDataGroup()
        
        //        список групп пользователя
        //VKGroupsService.loadGroupsUser()
        VKGroupsService.loadGroupsUser(controller: self)
        
        self.title = "мои группы"
        
        addRefreshControl()
        
        
    }
    
    @IBAction func addGroup (segue: UIStoryboardSegue) {
        
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            
            //Получаем ссылку на контроллер, с которого осуществлен переход
            let allGroupTableController = segue.source as! AllGroupTableController
  
            //Получаем индекс выделенной ячейки
            if let indexPath = allGroupTableController.tableView.indexPathForSelectedRow {
                // Получаем город по индексу
                let group = allGroupTableController.allFoundGroup[indexPath.row]
                print(group)
                // Проверяем, что такого города нет в списке
                //let userGroup = FireBaseUserGroups(userID: Session.instance.userId, groupID: group.id)
                //let ref = String(group.id) + String(Session.instance.userId)
                //let userGroupRef = self.ref.child(ref)
                //userGroupRef.setValue(userGroup.toAnyObject())
                
            }
        }
        
    }
    
    // MARK: - Table view data source
    
//    func loadDataGroup()
//       {
//           do {
//               
//               let realm = try Realm()
//               let groups = realm.objects(VKGroup.self)
//               self.allMyGroups = Array(groups)
//               print(self.self.allMyGroups)
//               self.tableView?.reloadData()
//           }
//           catch {
//               print(error)
//           }
//           
//       }
//    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return vkGroups?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupTableCell", for: indexPath) as! MyGroupTableCell
        // Получаем группу для строки
        let group = vkGroups?[indexPath.row]//allMyGroups[indexPath.row]
            //myGroup[indexPath.row]
        
        // Устанавливаем параметры группы
        cell.name.text = group?.name
        cell.groupType.text = " "//group.gType.description
        let iconUrl = URL(string: group?.photo50 ?? "")
        cell.iconShadow.image.af.setImage(withURL: iconUrl!) 
        return cell
    }
    
    func addRefreshControl (){
        controlRrefresh.attributedTitle = NSAttributedString(string: "Обновление...")
        controlRrefresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(controlRrefresh)
    }
    
    @objc func refreshTable ()
    {
        print("Start")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.controlRrefresh.endRefreshing()
        }
    }
    
    func pairTableAdnRealm() {

        guard let realm = try? Realm() else {return}
        vkGroups = realm.objects(VKGroup.self)
        token = vkGroups?.observe { [weak self]
            (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
                tableView.reloadData()

            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
}

extension MyGroupTableController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        myGroup = allMyGroups.filter{(group) -> Bool in return
            searchText.isEmpty ? true : group.name.lowercased().contains(searchText.lowercased())
        }

        
//        let realm = try Realm()
//        let frinds = realm.objects(MyFrineds.self).filter("firstName != %@","DELETED")
//        self.allMyFriend = Array(frinds)
//        
//        print(searchText.lowercased())
//        //поиск групп
//        AF.request("https://api.vk.com/method/groups.search",
//                   parameters: [
//                    "access_token" : Session.instance.token,
//                    "q": searchText.lowercased(),
//                    "type" : "group",
//                    "sort" : "2",
//                    "v" : "5.103"
//        ]).responseJSON {
//            response in
//            print(response.value)
//
//        }
        tableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
