//
//  NewsTableViewController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 21.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage
import Foundation

class NewsTableViewController: UITableViewController {
    
    var source: UIImageView?
    var vkBDGroups: Results<VKNewsGroup>?
    var vkFriend: Results<VKNewsProfile>?
    var token: NotificationToken?
    
    
    var vkMyNews: Results<VKNews>?
    var urlAvatarSource: URL!
    var sourceName: String = ""
    
    enum typeCell: String {
        case autur
        case footer
        case text
        case photos
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableNewsAndRealm()
    
        NewsService.loadAllNews ()

        //устанавливаем высоту ячейки
        tableView.estimatedRowHeight = 300.0

        //пересчитываем высоту ячеек
        tableView.rowHeight = UITableView.automaticDimension
        
        self.title = "новости"
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return vkMyNews?.count ?? 0
        //каждая новость будет секцией
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  vkMyNews?[section].countCellNews ?? 0
        // для каждой новости(секции) получаем кол-во ячеек
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let post = vkMyNews![indexPath.section]
        //нужно определииь какие типы ячеек есть в новости
        var arrayOfTypeCell: [typeCell] = []
   
        arrayOfTypeCell.append(.autur)
        //if !post.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty() {arrayOfTypeCell.append(.text)}
        if (post.text != ""  && post.text != " ")  {arrayOfTypeCell.append(.text)}
        if post.countPhoto > 0 { arrayOfTypeCell.append(.photos)}
        arrayOfTypeCell.append(.footer)
        
        let typeCell = arrayOfTypeCell[indexPath.row]
        
        switch typeCell {
        case .autur: do {
            //ячейка для вывода автора новости
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NewsAutorTableViewCell", for: indexPath) as! NewsAutorTableViewCell
        
            let sourceId = post.sourceId
            
            //если sourceId < 0 источник новости группа, будем получать запрос для групп 
            if sourceId < 0 {
                let groupInfo = getInfoGroup (id: (sourceId * (-1)))
                urlAvatarSource = URL(string: (groupInfo?.first?.photo50) ?? "")
                sourceName = groupInfo?.first?.name ?? "NoName"
            }
            else
            {
                let friendInfo = getFriendInfo(id: sourceId)
                urlAvatarSource = URL(string: (friendInfo?.first?.photo50) ?? "")
                sourceName = ((friendInfo?.first?.firstName ?? "NoName") + " " + (friendInfo?.first?.lastName ?? "NoName"))
            }

            dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
            let date = Date(timeIntervalSince1970: post.date)
            let stringDate = dateFormatter.string(from: date)

            
            cell.configure(autorName: sourceName, time: stringDate, avatarURL: urlAvatarSource)
            return cell
        }
           
        case .text: do {
            //ячейка для вывода текста новости
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextTableViewCell", for: indexPath) as! NewsTextTableViewCell
            //let post = vkMyNews[indexPath.section]
            cell.configure(text: post.text)
            
            return cell
        }
           
        case .photos: do {
            //ячнйка для вывода фотографий, содержит коллекцию
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
            //let newsPost = vkMyNews[indexPath.section]
            let postID = post.postId
            
            if post.countPhoto > 0 {
                cell.fotoNews = getPhotoPost(postID: postID)
            }
            else {
                //print("нет фото")
                cell.fotoNews = nil
            }

            cell.photoCollection.reloadData()
            cell.layoutIfNeeded()
            
            //получем высоту контента ячейки
            cell.photoCollectionHeight.constant = cell.photoCollection.contentSize.height
            return cell
            
        }
        case .footer: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterTableViewCell", for: indexPath) as! NewsFooterTableViewCell
            cell.commentBtn.countCount = post.commentCount
            print("post.commentCount \(post.commentCount)")
            cell.likeBtn.likeCount = post.likesCount
            cell.shareBtn.countShare = post.repostsCount
            cell.viewBtn.countView = post.viewsCount
            return cell
        }
        }
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func getInfoGroup (id: Int) -> Results<VKNewsGroup>? {
        
        guard let realm = try? Realm() else {return nil}
        let strFilter = "id == " + String(id)
        return realm.objects(VKNewsGroup.self).filter(strFilter)
    }
    
    func getFriendInfo (id: Int) -> Results<VKNewsProfile>?
    {
        guard let realm = try? Realm() else {return nil}
        let strFilter = "id == " + String(id)
        return realm.objects(VKNewsProfile.self).filter(strFilter)
    }
    
    func getPhotoPost (postID: Int) -> Results<VKNewsPhoto>?
    {
        guard let realm = try? Realm() else {return nil}
        let strFilter = "postID == " + String(postID)
        return realm.objects(VKNewsPhoto.self).filter(strFilter)
    }
    
    func pairTableNewsAndRealm() {
        guard let realm = try? Realm() else {return }
        vkMyNews = realm.objects(VKNews.self)
        
        token = vkMyNews?.observe { [weak self]
            (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                //устанавливаем высоту ячейки
                tableView.estimatedRowHeight = 300.0
               
                //пересчитываем высоту ячеек
                tableView.rowHeight = UITableView.automaticDimension
            case .update(_, let deletions, let insertions, let modifications):
                
                tableView.reloadData()
                //устанавливаем высоту ячейки
                tableView.estimatedRowHeight = 300.0
                
                //пересчитываем высоту ячеек
                tableView.rowHeight = UITableView.automaticDimension
            case .error(let error):
                fatalError("\(error)")
            }
        }
       
        
    }
    
    /*
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
     */
    
}
