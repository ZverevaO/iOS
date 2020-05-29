//
//  AllGroupTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AllGroupTableController: UITableViewController {
    
    
    @IBOutlet weak var searchBarAllGroup: UISearchBar!
    
    var allFoundGroup: [FoundGroup] = []
//    let allGroup: [Group] = [
//        Group(name: "HistoryPorn", count: 1000000, gType: Group.GroupType.history, fotoPath: "iconGroupVK"),
//        Group(name: "E-squire", count: 100000, gType: Group.GroupType.business, fotoPath: "iconGroupVK"),
//        Group(name: "Snob", count: 30000, gType: Group.GroupType.business, fotoPath: "iconGroupVK"),
//        Group(name: "Фобошная и Кофешная", count: 25000, gType: Group.GroupType.cafe, fotoPath: "iconGroupVK")
//    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarAllGroup.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allFoundGroup.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupTableCell", for: indexPath) as! AllGroupTableCell
        // Получаем группу для строки
        let group = allFoundGroup[indexPath.row]
        
        // Устанавливаем параметры группы
        cell.name.text = group.name
        //cell.groupType.text = group.gType.description
        let photoURL = URL(string: group.photo50)
        cell.icon.af.setImage(withURL: photoURL!)
        
        return cell
    }
    
}

extension AllGroupTableController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText.lowercased())
        //поиск групп
        AF.request("https://api.vk.com/method/groups.search",
                   parameters: [
                    "access_token" : Session.instance.token,
                    "q": searchText.lowercased(),
                    //"type" : "group",
                    "sort" : "0",
                    "v" : "5.103"
        ]).responseData {
            response in
            guard let data = response.value else {return}
            do {
                let dataVKFoundGroups =  try JSONDecoder().decode(VKFoundGroupsResponse.self, from: data).response.items
                self.allFoundGroup = dataVKFoundGroups
                    print(dataVKFoundGroups)
            }
            catch{
                print(error)
            }
            
        }
        tableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
