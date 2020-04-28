//
//  NewsTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class NewsTableController: UITableViewController, ImageViewPresenterSource  {
    
    var source: UIView? 
    
    let myComment: [Comment] = [Comment(nameUser: "Иван", text: "Отличная новость", icon: "iconFriend2"),
                                Comment(nameUser: "Петя", text: "Отличная новость", icon: "iconFriend2")]
    
   
    
    var myNews: [News] = [News(nameAutor: "Factura", textNews: "Представьте, что друзья сказали, что вам отведена роль шарика",  countLike: 5,countView: 234),
                          News(nameAutor: "Лучшее", textNews: "Пepвая eго фoтосеcсия. Mилота",  countLike: 7, countView: 234)]
    

    
    var controlRrefresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
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
        return myNews.count
        //
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableCell
        
        cell.avatar.image = UIImage(named: "iconGroupVK")
        cell.userName.text = myNews[indexPath.row].nameAutor
//        cell.countView.text = String(myNews[indexPath.row].countView)
        cell.newsText.text = myNews[indexPath.row].textNews
        cell.fotoNews = myNews[indexPath.row].newsFoto
        
        cell.viewClicked = { [weak self] view in
            guard let self = self else {return }
                self.source = view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "FotoController")
            let delegate =  ImageViewPresenter(delegate: self)
            self.navigationController?.delegate = delegate
            self.navigationController?.pushViewController(vc, animated: true)
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
    
}




