//
//  FotoCollectionController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import Alamofire

//private let reuseIdentifier = "Cell"

class FotoCollectionController: UICollectionViewController {
    
    
    var titelWindow : String = "галерея"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        фото друга
        AF.request("https://api.vk.com/method/photos.getAll",
                          parameters: [
                           "access_token" : Session.instance.token,
                           "owner_id" : "173716228",
                           "extended" : "0",
                           "count" : "10",
                           "no_service_albums" : "0",
                           "v" : "5.103"
               ]).responseJSON {
                   response in
                   print(response.value)
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
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionCell", for: indexPath) as! FotoCollectionCell
        
        let fname = "foto" + String(indexPath.item + 1)
        cell.foto.image = UIImage(named: fname)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFoto"
        {
            let fotoController: FotoController = segue.destination as! FotoController
            let indexPath = collectionView.indexPathsForSelectedItems!.first!
            let name = "foto" + String(indexPath.item + 1)
            fotoController.Foto = UIImage(named: name)
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
