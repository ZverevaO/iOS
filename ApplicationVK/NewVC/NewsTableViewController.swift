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

class NewsTableViewController: UITableViewController {
    
    var source: UIImageView?
    var vkBDGroups: Results<VKGroup>?
    var vkFriend: Results<MyFrineds>?
    
    
    var vkMyNews: [VKNews] = []
    var urlAvatarSource: URL!
    var sourceName: String = ""
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsService.loadAllNews() { [weak self] vkMyNews in
            self?.vkMyNews = vkMyNews
            self?.tableView?.reloadData()
        }
        
        //устанавливаем высоту ячейки
        tableView.estimatedRowHeight = 300.0
        
        //пересчитываем высоту ячеек
        tableView.rowHeight = UITableView.automaticDimension
        
        
        self.title = "новости"
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return vkMyNews.count
        //каждая новость будет секцией
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
        // для каждой новости(секции) 4 ячейки
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        //выбираем ячейку
        switch indexPath.row {
        case 0:
            //ячейка для вывода автора новости
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NewsAutorTableViewCell", for: indexPath) as! NewsAutorTableViewCell
            
            let post = vkMyNews[indexPath.section]
            
            let sourceId = post.sourceId
            
            if sourceId < 0 {
                let groupInfo = getInfoGroup (id: (sourceId*(-1)))
                urlAvatarSource = URL(string: (groupInfo?[0].photo50)!)!
                sourceName = groupInfo?[0].name ?? "NoName"
                
            }
            else
            {
                let friendInfo = getFriendInfo(id: sourceId)
                urlAvatarSource = URL(string: (friendInfo?[0].photo50)!)!
                sourceName = ((friendInfo?[0].firstName ?? "NoName") + " " + (friendInfo?[0].lastLame ?? "NoName"))
            }
            
            cell.avatar.af.setImage(withURL: urlAvatarSource)
            cell.autorName.text = sourceName
            
            dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
            let date = Date(timeIntervalSince1970: post.date)
            let stringDate = dateFormatter.string(from: date)
            cell.time.text = stringDate
            return cell
        case 1:
            //ячейка для вывода текста новости
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextTableViewCell", for: indexPath) as! NewsTextTableViewCell
            let post = vkMyNews[indexPath.section]
            cell.textPost.text = post.text ?? " "
            
            return cell
        case 2:
            //ячнйка для вывода фотографий, содержит коллекцию
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
            
            //получаем фотографии новости
            if  let photos = vkMyNews[indexPath.section].photos {
                // cell.fotoNews.removeAll()
                cell.fotoNews = photos
                //cell.newsText.text =   String(photos.count)
                print (photos.count)
            }
            else
            {
                print(vkMyNews[indexPath.section].photos)
                print("нет фото")
                //cell.fotoNews.removeAll()
                
            }
            cell.layoutIfNeeded()
            
            //получем высоту контента ячейки
            cell.photoCollectionHeight.constant = cell.photoCollection.contentSize.height
            
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterTableViewCell", for: indexPath) as! NewsFooterTableViewCell
            return cell
            
        default:
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NewsAutorTableViewCell", for: indexPath) as! NewsAutorTableViewCell
            return cell
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
    
    
    func getInfoGroup (id: Int) -> Results<VKGroup>? {
        
        guard let realm = try? Realm() else {return nil}
        let strFilter = "id == " + String(id)
        return realm.objects(VKGroup.self).filter(strFilter)
    }
    
    func getFriendInfo (id: Int) -> Results<MyFrineds>?
    {
        guard let realm = try? Realm() else {return nil}
        let strFilter = "id == " + String(id)
        return realm.objects(MyFrineds.self).filter(strFilter)
    }
    
}
