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
    
    
    var fotoNews1: [String] = ["news1"]
    let fotoNews2: [String] = ["news21", "news22", "news23"]
}


extension  NewsTableCell : UICollectionViewDataSource
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

extension NewsTableCell : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

extension NewsTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width - 41) / 2
        
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
