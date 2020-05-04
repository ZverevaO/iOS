//
//  NewsFotoController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 02.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class NewsFotoController : UIViewController
{
    var currentNewsFoto: UIImage!
    
    @IBOutlet weak var fotoNews: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       fotoNews.image = currentNewsFoto
       
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
}
