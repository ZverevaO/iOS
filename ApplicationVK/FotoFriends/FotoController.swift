//
//  FotoController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class FotoController: UIViewController {
    
    
    @IBOutlet weak var curentFoto: UIImageView!
    
    var Foto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curentFoto.image = Foto
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
}
