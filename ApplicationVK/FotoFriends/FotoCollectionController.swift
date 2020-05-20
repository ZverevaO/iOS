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

class FotoCollectionController: UICollectionViewController {
    
    
    var titelWindow : String = "галерея"
    var userowner: Int = 0
    var userPhotos: [VKPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        фото друга
        VKPhotosService.loadVKPhotoUser(userId: userowner) { [weak self] userPhotos  in
            self?.userPhotos = userPhotos
            self?.collectionView?.reloadData()
            
        }
        
        self.title = titelWindow
        updateNavigationItem ()
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
        
        let fname = NSURL(string: userPhotos[indexPath.item].url)
        //не понимаю почему тут не работает библиотека AlamofireImage
        //cell.foto.image?.af.setImage(fname as! URL)
        cell.foto.image = UIImage(data: try! Data(contentsOf: fname! as URL))

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFoto"
        {
            let fotoController: FotoController = segue.destination as! FotoController
            let cell: FotoCollectionCell = sender as! FotoCollectionCell
            let indexPath = collectionView.indexPathsForSelectedItems!.first!
            let name = "foto" + String(indexPath.item + 1)
            fotoController.Foto = UIImage(named: name)
            
            
            /*
             let fotoCollection: FotoCollectionController = segue.destination as! FotoCollectionController
             let cell: AllFriendTableCell = sender as! AllFriendTableCell
             
             fotoCollection.titelWindow = String(cell.name.text ?? " ") + " галерея"
             fotoCollection.userowner = cell.userId!
             //fotoCollection.userowner =
             print ("выбранный друг " + String(cell.name.text ?? " ") + String(cell.userId!))*/
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
