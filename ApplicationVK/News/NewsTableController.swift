//
//  NewsTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class NewsTableController: UITableViewController, ImageViewPresenterSource  {
    var source: UIImageView?
    var vkBDGroups: Results<VKGroup>?
    var vkFriend: Results<MyFrineds>?
    

    
    let myComment: [Comment] = [Comment(nameUser: "Иван", text: "Отличная новость", icon: "iconFriend2"),
                                Comment(nameUser: "Петя", text: "Отличная новость", icon: "iconFriend2")]
    

    var vkMyNews: [VKNews] = []
    var urlAvatarSource: URL!
    var sourceName: String = ""
    
    
    
    var controlRrefresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        
        NewsService.loadAllNews() { [weak self] vkMyNews in
            self?.vkMyNews = vkMyNews
            self?.tableView?.reloadData()
            
        }
        super.viewDidLoad()

        tableView.estimatedRowHeight = 300.0
        
        tableView.rowHeight = UITableView.automaticDimension
        
        
        self.title = "новости"
    
        addRefreshControl()
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vkMyNews.count
        //
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableCell
        
        
        
        let sourceId = vkMyNews[indexPath.row].sourceId
        
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
        cell.userName.text = sourceName
        
        //cell.avatar.image = UIImage(named: "iconGroupVK")
        //cell.userName.text = myNews[indexPath.row].nameAutor
        //cell.countView.text = String(vkMyNews[indexPath.row].viewsCount!)
        cell.newsText.text = vkMyNews[indexPath.row].text ?? " "//myNews[indexPath.row].textNews
        if  let photos = vkMyNews[indexPath.row].photos {
            cell.fotoNews.removeAll()
            cell.fotoNews = photos
            //cell.newsText.text =   String(photos.count)
        }
        else
        {
             print(vkMyNews[indexPath.row].photos)
             print("нет фото")
            cell.fotoNews.removeAll()
            
        }
        
// let data = response.value else {return}
        //cell.fotoNews = vkMyNews[indexPath.row].photos!
        
        cell.layoutIfNeeded()
        cell.collectionHeight.constant = cell.fotoCollection.contentSize.height
     
        
        cell.viewClicked = { [weak self] view in
            guard let self = self else {return }
                self.source = view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "NewsFotoController") as! NewsFotoController
            let delegate =  ImageViewPresenter(delegate: self)
            //vc.transitioningDelegate = delegate
            //vc.modalPresentationStyle = .fullScreen
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.delegate = delegate
            self.navigationController?.pushViewController(vc, animated: true)
    
            vc.currentNewsFoto = self.source?.image
            
        }
        
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




