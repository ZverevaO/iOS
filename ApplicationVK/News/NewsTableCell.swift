//
//  NewsTableCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsTableCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var newsText: UILabel!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var likeBtn: LikeButton!
    
    @IBOutlet weak var commentBtn: CommentButton!
    
    @IBOutlet weak var shareBtn: ShareButton!
    
    @IBOutlet weak var viewBtn: ViewButton!
    
    
    @IBAction func likeButton(_ sender: LikeButton) {
        sender.like()
    }
    
    @IBAction func commentButton(_ sender: UIButton) {
        
    }
    
    
    
    @IBOutlet weak var fotoCollection: UICollectionView!
    
    var viewClicked: ((UIImageView)->())? = nil
    var fotoNews: [VKNewsPhoto] = []
    
   

}


extension  NewsTableCell : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return fotoNews.count
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsFotoCollectionCell", for: indexPath) as! NewsFotoCollectionCell
        let stringUrl = URL(string: fotoNews[indexPath.item].urlX)
        //cell.foto.image? = nil 
        cell.foto.image = nil
        cell.foto.af.setImage(withURL: stringUrl!)
        //cell.foto.image = UIImage(named: fotoNews[indexPath.item])
        
        cell.imageClicked = {
            image in
            self.viewClicked?(image)
            
        }
        return cell
    }
    
}

extension NewsTableCell : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

extension NewsTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width - 7) / 2
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
