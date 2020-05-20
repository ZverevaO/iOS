//
//  AllFriendTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


struct Section <T> {
    var title: String
    var items: [T]
}



class AllFriendTableController: UITableViewController {
    
    
    var allMyFriend =  [MyFrineds]()
    var myFriendSection = [Section<MyFrineds>]()
    
    @IBOutlet weak var searchFriend: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        нужно получить данные друзей
        FriendService.loadAlllFriend() { [weak self] allMyFriend in
            self?.allMyFriend = allMyFriend
            let myFriendsDictionary = Dictionary.init(grouping: allMyFriend) {
                $0.lastLame.prefix(1)
                
            }
            
            //формируем секции по словарю
            self?.myFriendSection = myFriendsDictionary.map {Section(title: String($0.key), items: $0.value)}
            //сортируем секции
            self?.myFriendSection.sort {$0.title < $1.title}
            self?.tableView?.reloadData()
        }
        
        self.title = "друзья"
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myFriendSection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // возвращаем количесво элементов секции
        return myFriendSection[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendTableCell", for: indexPath) as! AllFriendTableCell
        // Получаем друзей из секции
        let friend = myFriendSection[indexPath.section].items[indexPath.row]
        // ранее получали просто массив друзей let friend = allFriend[indexPath.row]
        
        // Устанавливаем параметры друга
        cell.name.text = friend.firstName + " " + friend.lastLame
        var online = ""
        if friend.online == 1 {
           online = "online"
        }
        cell.city.text = online
        
        let url = URL(string: friend.photo50)
        cell.shadowFoto.image.af.setImage(withURL: url!)
        cell.userId = friend.id
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return myFriendSection[section].title
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //добавлем заголовки секций
        return myFriendSection.map {$0.title}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCollectionFoto"
        {
            let fotoCollection: FotoCollectionController = segue.destination as! FotoCollectionController
            let cell: AllFriendTableCell = sender as! AllFriendTableCell
            
            fotoCollection.titelWindow = String(cell.name.text ?? " ") + " галерея"
            fotoCollection.userowner = cell.userId!
            //fotoCollection.userowner =
            print ("выбранный друг " + String(cell.name.text ?? " ") + String(cell.userId!))

        }
        
    }
    
}


extension AllFriendTableController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // не работает нужно поправить
        
        let friendsDictionary = Dictionary.init(grouping: allMyFriend.filter{(user) -> Bool in return searchText.isEmpty ? true : user.firstName.lowercased().contains(searchText.lowercased()) || user.lastLame.lowercased().contains(searchText.lowercased())
        }) {
            $0.lastLame.prefix(1)
        }
        
        
        //формируем секции по словарю
        myFriendSection = friendsDictionary.map {Section(title: String($0.key), items: $0.value)}
        //сортируем секции
        myFriendSection.sort {$0.title < $1.title}
        
        tableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

