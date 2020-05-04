//
//  CustomCollectionViewLayout.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 12.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class CastomCollectionViewLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columnsCount = 2
    var cellHeight: CGFloat = 100
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        cacheAttributes = [:]
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return }
        
//        let bigCellWidth = collectionView.bounds.width
//        let smallCellWidth = collectionView.bounds.width / CGFloat(columnsCount)
        
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = (collectionView.frame.width / CGFloat(columnsCount))
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
       
      
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributtes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (((index + 1) % (columnsCount + 1)) == 0)
            
            if isBigCell {
                attributtes.frame = CGRect(x: 0,
                                           y: lastY,
                                           width: bigCellWidth,
                                           height: cellHeight)
                lastY += cellHeight
            } else {
                attributtes.frame = CGRect(x: lastX,
                                           y: lastY,
                                           width: smallCellWidth,
                                           height: cellHeight)
                
                let isLastColumn = (index + 2) % (columnsCount + 1) == 0 || index == (itemsCount - 1)
                
                if isLastColumn {
                    lastX = 0
                    lastY += cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            cacheAttributes[indexPath] = attributtes
        }
        totalCellsHeight = lastY
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0,
                      height: totalCellsHeight)
    }
}
