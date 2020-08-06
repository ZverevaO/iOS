//
//  FriensGalleryController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 19.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import AsyncDisplayKit

//создаем контроллер для галлерии
//содержит коллекцию для альбомов и все фото пользователя
class FriensGalleryController: ASDKViewController<ASDisplayNode> {

    // Создаем дополнительный интерфейс для обращения к корневой ноде
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    private var userId: Int
    
    init(userId: Int) {
        let tableNode = ASTableNode(style: .plain)
        self.userId = userId
        super.init(node: tableNode)
        
       
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FriensGalleryController: ASTableDataSource {
    /// Displaying three sections.
    /// Topmost for big photo header with description.
    /// Second is for comics collection with this character
    /// Third one displays series in which this character took part.
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Альбомы"
        case 1:
            return "Все фотографии"
        default:
            return nil
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        switch indexPath.section {
        case 0:  return node as! ASCellNode
            //return CharacterDetailNode(character: character)
        case 1:
//            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
//                return HorizontalScrollController<ComicsResponse>(character: self.character, dataProvider: self.dataProvider)
//            })
//            node.style.maxSize = CGSize(width: Constants.comicsHeight, height: Constants.comicsHeight)
//
            return node as! ASCellNode
        case 2:
//            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
//                return HorizontalScrollController<SeriesResponse>(character: self.character, dataProvider: self.dataProvider)
//            })
//            node.style.maxSize = CGSize(width: Constants.seriesHeight, height: Constants.seriesHeight)
            
        return node as! ASCellNode
        default:
            preconditionFailure("Check number of sections properly")
        }
    }
}
