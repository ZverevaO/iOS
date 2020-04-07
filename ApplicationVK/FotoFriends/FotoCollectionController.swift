//
//  FotoCollectionController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class FotoCollectionController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
            
        self.title = "галерея"
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

    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.identifier == "goFoto"
              {
                  // Даём понять, что sender это ячейка класса MyCell
                  let cell: FotoCollectionCell  = sender as! FotoCollectionCell
                      
                  // Получает объект image из текущей ячейки
                  let image = cell.foto.image
                      
                  // Даём понять, что destinationViewController это контроллер класса
                  let previewVC: FotoController = segue.destination as! FotoController
                      
                  // Задаём контроллеру изображение с текущей ячейки
                  previewVC.curentFoto.image = image
              }
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fotoVC = segue.destination as? FotoController {
            let indexPath = collectionView.indexPathsForSelectedItems!.first!
            let name = "foto" + String(indexPath.item + 1)
            fotoVC.Foto = UIImage(named: name)
        }
    }
}
