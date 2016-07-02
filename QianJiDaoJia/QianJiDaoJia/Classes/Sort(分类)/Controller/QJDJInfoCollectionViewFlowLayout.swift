//
//  QJDJInfoCollectionViewFlowLayout.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJInfoCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // 列数
//    private let cols = 3
    private let categoryTableWidth: CGFloat = 100
    override func prepareLayout() {
        super.prepareLayout()
        let itemWH = (UIScreen.mainScreen().bounds.width - categoryTableWidth) / 3
        
        itemSize = CGSize(width: itemWH, height: itemWH)

        minimumLineSpacing = 0
        
        minimumInteritemSpacing = 0
        
        
    }
}
