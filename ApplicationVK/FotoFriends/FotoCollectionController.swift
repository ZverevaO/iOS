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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataPhotoFriend(userId: userowner)
        //        фото друга
        VKPhotosService.loadVKPhotoUser(userId: userowner) { [weak self]
            in
           // self?.userPhotos = userPhotos
            self?.loadDataPhotoFriend(userId: self!.userowner)
            //self?.collectionView?.reloadData()
            
        }
        
        self.title = titelWindow
        updateNavigationItem ()
    }
    
   
    
    
    func loadDataPhotoFriend(userId: Int)
       {
           do {
               
               let realm = try Realm()
               let strFilter = "ownerId == " + String(userId)
               let photos = realm.objects(VKPhoto.self).filter(strFilter)
               self.userPhotos = Array(photos)
               
               print(self.self.userPhotos)
               self.collectionView.reloadData()
           }
           catch {
               print(error)
           }
           
       }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionCell", for: indexPath) as! FotoCollectionCell
        
        let fname = URL(string: userPhotos[indexPath.item].url)
        //не понимаю почему тут не работает библиотека AlamofireImage
        cell.foto?.af.setImage(withURL: fname!)
        //cell.foto.image = UIImage(data: try! Data(contentsOf: fname! as URL))
        cell.urlPhoto = URL(string: userPhotos[indexPath.item].urlX)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFoto"
        {
            let fotoController: FotoController = segue.destination as! FotoController
            let cell: FotoCollectionCell = sender as! FotoCollectionCell
    
            fotoController.photoUrl = cell.urlPhoto

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
