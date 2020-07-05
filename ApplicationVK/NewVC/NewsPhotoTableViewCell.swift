//
//  NewsPhotoTableViewCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 21.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import RealmSwift

class NewsPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoCollection: NewsPhotoCollectionView!
    
    @IBOutlet weak var photoCollectionHeight: NSLayoutConstraint!
    
    var fotoNews: Results<VKNewsPhoto>? //[VKNewsPhoto] = []
    var PostID: Int = 0
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




extension  NewsPhotoTableViewCell : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return fotoNews?.count ?? 0
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let stringUrl = URL(string: fotoNews![indexPath.item].urlX)
        //let photo = fotoNews![indexPath.item]
        //cell.foto.image? = nil
        cell.photoNews.image = nil
        cell.photoNews.af.setImage(withURL: stringUrl!)
        //cell.foto.image = UIImage(named: fotoNews[indexPath.item])
        //print("ид новости \(photo.postID)")
        return cell
    }
    
}


extension NewsPhotoTableViewCell : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

//extension NewsPhotoTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        //let cellWidth = (collectionView.bounds.width - 4) / 2
//        
//       // return CGSize(width: cellWidth, height: cellWidth)
//    }
//}


/*extension NewsTableCell: UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let cellWidth = (collectionView.bounds.width - 7) / 2
    
    return CGSize(width: cellWidth, height: cellWidth)
}*/
