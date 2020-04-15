//
//  NewsTableController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class NewsTableController: UITableViewController {
    
    let myComment: [Comment] = [Comment(nameUser: "Иван", text: "Отличная новость", icon: "iconFriend2"),
                                Comment(nameUser: "Петя", text: "Отличная новость", icon: "iconFriend2")]
    
   
    
    let myNews: [News] = [News(nameAutor: "Factura", textNews: "Представьте, что друзья сказали, что вам отведена роль шарика",  countLike: 5,countView: 234),
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
        cell.countView.text = String(myNews[indexPath.row].countView)
        cell.newsText.text = myNews[indexPath.row].textNews
        
        
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

/*extension  NewsTableController : UICollectionViewDataSource
{
  func numberOfSections(in collectionView: UICollectionView) -> Int
  {
      return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fotoNews2.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsFotoCollectionCell", for: indexPath) as! NewsFotoCollectionCell
      
    cell.foto.image = UIImage(named: fotoNews2[indexPath.item])
      
      return cell
  }
    
}

extension NewsTableController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

}

extension NewsTableController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width - 41) / 3
        
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}*/

