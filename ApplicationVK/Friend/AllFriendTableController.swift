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
import RealmSwift


struct Section <T> {
    var title: String
    var items: [T]
}


class AllFriendTableController: UITableViewController {
    
    var allMyFriend =  [Friend]()//[MyFrineds]()
    var myFriendSection = [Section<Friend>]()//[Section<MyFrineds>]()
    var token: NotificationToken?
    var vkFrends: [Friend] = []//Results<MyFrineds>?
    
    private let viewModelFactory = FriendViewModelFactory()
    private var viewModels = [FriendViewModel]()
    private var friendVMSection = [Section<FriendViewModel>]()
    
    let friendService = FriendAdapter()
    
    @IBOutlet weak var searchFriend: UISearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFriend.delegate = self
        //pairTableFriendsAdnRealm()
        //FriendService.friendPromise()
        
        friendService.getFriends {[weak self] friends in
            guard let self = self else { return }
            
            self.vkFrends = friends
            print ("получили друзей \(friends.count)")
            self.allMyFriend = friends
            self.getSectionFrieds(frieds: self.vkFrends)
            
            self.viewModels = self.viewModelFactory.constructViewModels(from: friends)
            self.getSectionFriendsVM(friedsVM:  self.viewModels)
            
            self.tableView.reloadData()
            
        }
  
        self.title = "друзья"
        
    }
    

//    func pairTableFriendsAdnRealm() {
//        guard let realm = try? Realm() else {return}
//        vkFrends = realm.objects(MyFrineds.self).filter("firstName != %@","DELETED")
//        token = vkFrends?.observe { [weak self]
//            (changes: RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                self!.getSection(frieds: self?.vkFrends)
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                self!.getSection(frieds: self?.vkFrends)
//                tableView.reloadData()
//                
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//    }
    
//    func getSection (frieds: Results<MyFrineds>?)
//    {
//
//        let myFriendsDictionary = Dictionary.init(grouping: (frieds!)) {
//            $0.lastLame.prefix(1)
//        }
//        //формируем секции по словарю
//        self.myFriendSection = myFriendsDictionary.map {Section(title: String($0.key), items: $0.value)}
//        //сортируем секции
//        self.myFriendSection.sort {$0.title < $1.title}
//    }
    
    private func getSectionFriendsVM (friedsVM: [FriendViewModel]) {
        let myFriendsDictionary = Dictionary.init(grouping: (friedsVM)) {
            $0.nameFriend.prefix(1)
        }
        self.friendVMSection = myFriendsDictionary.map {Section(title: String($0.key), items: $0.value)}
        //сортируем секции
        self.friendVMSection.sort {$0.title < $1.title}
        
    }
    
      func getSectionFrieds (frieds: [Friend])
      {
    
          let myFriendsDictionary = Dictionary.init(grouping: (frieds)) {
              $0.lastLame.prefix(1)
          }
          //формируем секции по словарю
          self.myFriendSection = myFriendsDictionary.map {Section(title: String($0.key), items: $0.value)}
          //сортируем секции
          self.myFriendSection.sort {$0.title < $1.title}
      }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return myFriendSection.count
        return friendVMSection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // возвращаем количесво элементов секции
        //return myFriendSection[section].items.count
        return friendVMSection[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendTableCell", for: indexPath) as! AllFriendTableCell
        // Получаем друзей из секции
        let friend = friendVMSection[indexPath.section].items[indexPath.row]

        cell.configure(with: friend)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendVMSection[section].title
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //добавлем заголовки секций
        return friendVMSection.map {$0.title}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCollectionFoto"
        {
            let fotoCollection: FotoCollectionController = segue.destination as! FotoCollectionController
            let cell: AllFriendTableCell = sender as! AllFriendTableCell
            
            //fotoCollection.titelWindow = String(cell.name.text ?? " ") + " галерея"
            fotoCollection.userowner = cell.getUser()
            //print ("выбранный друг " + String(cell.name.text ?? " ") + String(cell.userId!))
        }
        
    }
    
}


extension AllFriendTableController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

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

