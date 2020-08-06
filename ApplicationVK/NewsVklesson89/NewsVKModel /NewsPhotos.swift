//
//  NewsPhotos.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 26.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import UIKit

class NewsPhotos  {
    var date: Int = 0
    var id: Int = 0
    var url: String = ""
    var urlX: String = ""
    var postID: Int = 0
    var width: Int = 0
    var height: Int = 0
    var aspectRatio: CGFloat
    
    init (date: Int, id: Int, url: String, urlX: String, postID: Int, width: Int, height: Int)
    {
        
        self.date = date
        self.id = id
        self.url = url
        self.urlX = urlX
        self.postID = postID
        self.height = height
        self.width = width
        self.aspectRatio = CGFloat(width) / CGFloat(height)
    }
    
    
}
