//
//  FotoCollectionController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift

class FotoCollectionController: UICollectionViewController {
    
    
    var titelWindow : String = "галерея"
    var userowner: Int = 0
    var userPhotos: [VKPhoto] = []
    var token: NotificationToken?
    var vkPhotos: Results<VKPhoto>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairPhotoTableAdnRealm(userId: userowner)
        //loadDataPhotoFriend(userId: userowner)
        //        фото друга
        VKPhotosService.loadVKPhotoUser(userId: userowner) 
        
        self.title = titelWindow
        updateNavigationItem ()
    }
    
   
    
    
//    func loadDataPhotoFriend(userId: Int)
//       {
//           do {
//               
//               let realm = try Realm()
//               let strFilter = "ownerId == " + String(userId)
//               let photos = realm.objects(VKPhoto.self).filter(strFilter)
//               self.userPhotos = Array(photos)
//               
//               print(self.self.userPhotos)
//               self.collectionView.reloadData()
//           }
//           catch {
//               print(error)
//           }
//           
//       }
    
    func pairPhotoTableAdnRealm(userId: Int) {
        
        guard let realm = try? Realm() else {return}
        let strFilter = "ownerId == " + String(userId)
        vkPhotos = realm.objects(VKPhoto.self).filter(strFilter)
        token = vkPhotos?.observe { [weak self]
            (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
                collectionView.reloadData()
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return vkPhotos!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "FotoCollectionCell", for: indexPath) as! FotoCollectionCell
        
        let photo = vkPhotos![indexPath.item]
        let fname = URL(string: photo.url)
        //не понимаю почему тут не работает библиотека AlamofireImage
        cell.foto?.af.setImage(withURL: fname!)
        //cell.foto.image = UIImage(data: try! Data(contentsOf: fname! as URL))
        cell.urlPhoto = URL(string: photo.urlX)
        cell.ownerId = photo.ownerId

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFoto"
        {
            let fotoController: FotoController = segue.destination as! FotoController
            let cell: FotoCollectionCell = sender as! FotoCollectionCell
    
            fotoController.photoUrl = cell.urlPhoto
            fotoController.userIdByPhotos = cell.ownerId

        }
        
    }
    
    func updateNavigationItem ()
    {
        let backItemButton = UIBarButtonItem()
        backItemButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItemButton
    }
}


extension FotoCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width - 7) / 2
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
