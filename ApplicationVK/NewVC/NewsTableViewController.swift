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

enum typeCell: String {
    case autur
    case footer
    case text
    case photos
}

class NewsTableViewController: UITableViewController {
    
    private var source: UIImageView?
    private var vkBDGroups: Results<VKNewsGroup>?
    private var vkFriend: Results<VKNewsProfile>?
    private var token: NotificationToken?
    private var vkMyNews: Results<VKNews>?
    
    var vkNewsArray = [VKNews]()
    var vkProfileArray = [VKNewsProfile]()
    var vkGroupArray = [VKNewsGroup]()
    var vkNewsPhotoArray =  [Int: [VKNewsPhoto]]()
    
    private var urlAvatarSource: URL!
    private var sourceName: String = ""
    
    let maxHeightOfTextBlock: CGFloat = 200.0
    
    private var controlRrefresh = UIRefreshControl()
    let newsService = NewsService()

    fileprivate var nextFrom = ""
    fileprivate var isLoading = false
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        
        pairTableNewsAndRealm()
    
        NewsService.loadAllNews(startfrom: Session.instance.nextFrom)

        //устанавливаем высоту ячейки
        tableView.estimatedRowHeight = 300.0

        //пересчитываем высоту ячеек
        tableView.rowHeight = UITableView.automaticDimension
        
        self.title = "новости"
        
        // Указываем, что мы делегат
        tableView.prefetchDataSource = self

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return vkMyNews?.count ?? 0
        //каждая новость будет секцией
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  4 //vkMyNews?[section].countCellNews ?? 0
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
        
        //let typeCell = arrayOfTypeCell[indexPath.row]
        
        //switch typeCell {
        switch indexPath.row {
        case  0: do {//.autur: do {
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
           
        case 1: do { //.text: do {
            //ячейка для вывода текста новости
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextTableViewCell", for: indexPath) as! NewsTextTableViewCell
            //let post = vkMyNews[indexPath.section]
            cell.configure(text: post.text)
            
            return cell
        }
           
        case 2: do {//.photos: do {
            let postID = post.postId
            let photoList = getPhotoPost(postID: postID)
            
//            if post.countPhoto == 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsOnePhotoTableViewCell", for: indexPath) as! NewsOnePhotoTableViewCell
//                let url = URL(string: photoList?.first?.urlX ?? "")
//                cell.configure(photoURL: url)
//                return cell
//            }
//            else {
                //ячнйка для вывода фотографий, содержит коллекцию
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
                cell.fotoNews = photoList //getPhotoPost(postID: postID)
                cell.photoCollection.reloadData()
                cell.layoutIfNeeded()
                
                //получем высоту контента ячейки
                cell.photoCollectionHeight.constant = cell.photoCollection.contentSize.height
                return cell
            //}
            
            
            
        }
        case 3: do { //.footer: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterTableViewCell", for: indexPath) as! NewsFooterTableViewCell
            cell.commentBtn.countCount = post.commentCount
            print("post.commentCount \(post.commentCount)")
            cell.likeBtn.likeCount = post.likesCount
            cell.shareBtn.countShare = post.repostsCount
            cell.viewBtn.countView = post.viewsCount
            return cell
        }
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterTableViewCell", for: indexPath) as! NewsFooterTableViewCell
             return cell
        }
    }
    

    
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
        
        /*
         private var vkBDGroups: Results<VKNewsGroup>?
           private var vkFriend: Results<VKNewsProfile>?*/
        
//        token = vkMyNews?.observe { [weak self]
//            (changes: RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//                //устанавливаем высоту ячейки
//                tableView.estimatedRowHeight = 300.0
//
//                //пересчитываем высоту ячеек
//                tableView.rowHeight = UITableView.automaticDimension
//            case .update(_, let deletions, let insertions, let modifications):
//
//                tableView.reloadData()
//                //устанавливаем высоту ячейки
//                tableView.estimatedRowHeight = 300.0
//
//                //пересчитываем высоту ячеек
//                tableView.rowHeight = UITableView.automaticDimension
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
        
        token = realm.observe { [weak self] notification, realm in
            guard let tableView = self?.tableView else { return }
            
            //self.datasource = realm.objects(AnObject.self)
            tableView.reloadData()
            //устанавливаем высоту ячейки
            tableView.estimatedRowHeight = 300.0
            
            //пересчитываем высоту ячеек
            tableView.rowHeight = UITableView.automaticDimension
        }
       
        
    }
    
    // Функция настройки контроллера
    fileprivate func setupRefreshControl() {
        controlRrefresh.attributedTitle = NSAttributedString(string: "Loading...")
        controlRrefresh.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.addSubview(controlRrefresh)
    }
    
    @objc func refreshNews() {
        // Начинаем обновление новостей
        self.controlRrefresh.beginRefreshing()
        let mostFreshNewsDate = self.vkMyNews?.first?.date ??  Date().timeIntervalSince1970
        
        //NewsService.loadAllNews(startfrom: String(mostFreshNewsDate + 1))
         //self.refreshControl?.endRefreshing()
  
        print("Start")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.controlRrefresh.endRefreshing()
        }
  
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let postNews = self.vkMyNews?[indexPath.section] else {return UITableView.automaticDimension}
        
        switch indexPath.row {
        
        case 1: do {
            //Ячейка с текстом новости
            let textBlock = postNews.text
            
            if  !textBlock.isEmpty {
                let autoSize = UITableView.automaticDimension
                if autoSize > maxHeightOfTextBlock {
                    return maxHeightOfTextBlock
                }
                return autoSize
            } else {
                return 0
            }
            }
            
        // Ячейки с фото у нас, например, имеют .row == 2
        case 2:
            let countPhoto = postNews.photos?.count ?? 0
            
            if postNews.countPhoto <= 0 {
                return 0
            }
            else if postNews.countPhoto == 1 {
                //тут должен быть расчет ячейки, но почему-то мне могу получить массив фото, всегда пустой
                 //guard let photo = postNews.photos?.first else {return UITableView.automaticDimension }
                //                let photo = postNews.photos?.first
                //                let aspectRatio: CGFloat = CGFloat(photo!.height) / CGFloat(photo!.width)
                //                let cellHeight = tableWidth * aspectRatio
                //                return cellHeight
                 let aspectRatio: CGFloat = 500
                return aspectRatio//UITableView.automaticDimension
            }
            else {
                return UITableView.automaticDimension
            }

        default:
        // Для всех остальных ячеек оставляем автоматически определяемый размер
                return UITableView.automaticDimension
        }
    }


    
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        print ("!!!!!!! дозагружаем новости")
        // Выбираем максимальный номер секции, которую нужно будет отобразить в ближайшее время
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        // Проверяем,является ли эта секция одной из трех ближайших к концу
        if maxSection > vkMyNews!.count - 3, !isLoading {
            // Начинаем загрузку данных и меняем флаг isLoading
            self.isLoading = true
            
//            newsService.loadPartVKNews(startfrom: Session.instance.nextFrom, completion: {
//                [weak self] news, profile, group, photo, Error, dateFrom in
//                guard let self = self else { return}
//
//                print("комплишен запроса")
//                self.vkNewsArray = news ?? []
//                self.vkProfileArray = profile ?? []
//                self.vkGroupArray = group ?? []
//                self.vkNewsPhotoArray = photo ?? [:]
//
//                NewsService.saveNews(self.vkNewsArray, needRemove: false)
//                NewsService.saveNewsGroups(self.vkGroupArray, needRemove: false)
//                NewsService.saveNewsPofiles(self.vkProfileArray, needRemove: false)
//                for photo in self.vkNewsPhotoArray.values {
//                    NewsService.saveNewsPostPhoto(photo)
//                }
//
//                let indexSet = IndexSet(integersIn: self.vkMyNews!.count ..< self.vkMyNews!.count + news!.count)
//                //self.news.append(contentsOf: news)
//
//
//                self.tableView.insertSections(indexSet, with: .automatic)
//                // Выключаем статус isLoading
//                self.isLoading = false
//
//            })
            
        }
        
        
    }
}


