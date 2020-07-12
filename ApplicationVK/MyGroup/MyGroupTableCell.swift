//
//  MyGroupTableCell.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 01.04.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class MyGroupTableCell: UITableViewCell {
    
    @IBOutlet private weak var iconShadow: CircleShadowImage! {
        didSet {
            iconShadow.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.translatesAutoresizingMaskIntoConstraints = false
            name.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var groupType: UILabel! {
        didSet {
            groupType.translatesAutoresizingMaskIntoConstraints = false
            groupType.backgroundColor = .white
        }
    }
    
    
    @IBOutlet private weak var stackLabel: UIStackView! {
        didSet {
            stackLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private let iconViewHeight: CGFloat = 55
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconShadowFrame()
        stackLabelFrame()
    }
    
    func configure (groupName: String, typeGroup: String, avatarGroup: UIImage?)
    {
        name.text = groupName
        groupType.text = typeGroup
        iconShadow.image.image = avatarGroup
    }
    
    private func iconShadowFrame() {
        
        iconShadow.frame = CGRect(x: floor(contentView.bounds.minX + 10),
                                  y: floor(contentView.bounds.midY - iconViewHeight/2),
                                  width: iconViewHeight,
                                  height: iconViewHeight)
    }
    
    private func stackLabelFrame() {
        let stackLabelSize = stackLabel.intrinsicContentSize
        // рассчитываем координату по оси Х
        let stackLabelX = contentView.bounds.minX + 75
        // рассчитываем координату по оси Y
        let stackLabelY = contentView.bounds.maxY - 10
        
        let stackLabelOrigin =  CGPoint(x: stackLabelX, y: stackLabelY)
        
        stackLabel.frame = CGRect(x: stackLabelX,
                                  y: stackLabelY,
                                  width: contentView.bounds.maxX-85,
                                  height: contentView.bounds.maxY-20) //CGRect(origin: stackLabelOrigin, size: stackLabelSize)
    }
}
