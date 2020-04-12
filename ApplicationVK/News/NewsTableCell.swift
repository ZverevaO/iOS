//
//  NewsTableCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class NewsTableCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var newsText: UILabel!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBAction func likeButton(_ sender: LikeButton) {
        sender.like()
    }
    
    @IBAction func commentButton(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var countView: UILabel!
    
    @IBOutlet weak var fotoCollection: UICollectionView!
    
    
}


/*extension  NewsTableCell : UICollectionViewDataSource
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
      
    cell.foto.image = UIImage(named: fotoNews2[1])
      
      return cell
  }
}

extension NewsTableCell : UICollectionViewDelegate
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
