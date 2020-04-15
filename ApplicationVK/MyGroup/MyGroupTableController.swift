//
//  MyGroupTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class GroupDB {
   static func  getGroups () -> [Group] {
        return [Group(name: "группа1", count: 300000, gType: Group.GroupType.cityGroup, fotoPath: "iconGroupVK"), Group(name: "группа2", count: 300000, gType: Group.GroupType.cityGroup, fotoPath: "iconGroupVK"),
                Group(name: "группа3", count: 300000, gType: Group.GroupType.cityGroup, fotoPath: "iconGroupVK")]
    }
    
    
}

class MyGroupTableController: UITableViewController {
    
    var myGroup = GroupDB.getGroups()
    
    @IBOutlet weak var groupSearch: UISearchBar!
    
    
    var controlRrefresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "мои группы"

       addRefreshControl()
        
        groupSearch.delegate = self
    }
    
    @IBAction func addGroup (segue: UIStoryboardSegue) {
        
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let allGroupTableController = segue.source as! AllGroupTableController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = allGroupTableController.tableView.indexPathForSelectedRow {
                // Получаем город по индексу
                let group = allGroupTableController.allGroup[indexPath.row]
                // Проверяем, что такого города нет в списке
                if !myGroup.contains(group) {
                    // Добавляем город в список выбранных
                    myGroup.append(group)
                    // Обновляем таблицу
                    tableView.reloadData()
                }
                
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroup.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupTableCell", for: indexPath) as! MyGroupTableCell
        // Получаем группу для строки
        let group = myGroup[indexPath.row]
        
        // Устанавливаем параметры группы
        cell.name.text = group.name
        cell.groupType.text = group.gType.description
        cell.icon.image = UIImage(named: group.fotoPath)
        
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

}

extension MyGroupTableController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        myGroup = GroupDB.getGroups().filter{(group) -> Bool in return
            searchText.isEmpty ? true : group.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
