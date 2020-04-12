//
//  AllFriendTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

struct Section <T> {
    var title: String
    var items: [T]
}

class AllFriendTableController: UITableViewController {

    var allFriend = AllFriends.getAllFriend ()
    
    var friendSection = [Section<Friend>]()
    
    @IBOutlet weak var searchFriend: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "друзья"
        // создаем словарь
        let friendsDictionary = Dictionary.init(grouping: allFriend) {
            $0.name.prefix(1)
        }
        
        //формируем секции по словарю
        friendSection = friendsDictionary.map {Section(title: String($0.key), items: $0.value)}
        //сортируем секции
        friendSection.sort {$0.title < $1.title}
        
        searchFriend.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return friendSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // возвращаем количесво элементов секции
        return friendSection[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendTableCell", for: indexPath) as! AllFriendTableCell
        // Получаем друзей из секции
        let friend = friendSection[indexPath.section].items[indexPath.row]
        // ранее получали просто массив друзей let friend = allFriend[indexPath.row]
        
        // Устанавливаем параметры друга
        cell.name.text = friend.name + " " + friend.surName
        cell.city.text = friend.city
        cell.shadowFoto.image.image = UIImage(named: friend.fotoPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendSection[section].title
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //добавлем заголовки секций
        return friendSection.map {$0.title}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCollectionFoto"
        {
            let fotoCollection: FotoCollectionController = segue.destination as! FotoCollectionController
            let cell: AllFriendTableCell = sender as! AllFriendTableCell
            
            fotoCollection.titelWindow = String(cell.name.text ?? " ") + " галерея"
        }
        
    }

}

extension AllFriendTableController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
        
        let friendsDictionary = Dictionary.init(grouping: allFriend.filter{(user) -> Bool in return searchText.isEmpty ? true : user.surName.lowercased().contains(searchText.lowercased()) || user.name.lowercased().contains(searchText.lowercased())
        }) {
            $0.name.prefix(1)
        }
              
        //формируем секции по словарю
        friendSection = friendsDictionary.map {Section(title: String($0.key), items: $0.value)}
        //сортируем секции
        friendSection.sort {$0.title < $1.title}
        
        tableView.reloadData()
              
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

