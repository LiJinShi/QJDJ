//
//  QJDJDetailFlowLayout_1.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJDetailFlowLayout_1: UICollectionViewFlowLayout {
    // 列数
    let cols = 1
    let itemW: CGFloat = UIScreen.mainScreen().bounds.width
    let itemH: CGFloat = 90
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = 5
        minimumInteritemSpacing = 0
    }
}
