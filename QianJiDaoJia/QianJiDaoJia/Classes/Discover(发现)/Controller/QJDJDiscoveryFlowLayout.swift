//
//  QJDJDiscoveryFlowLayout.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/20.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJDiscoveryFlowLayout: UICollectionViewFlowLayout {

    let mairgn: CGFloat = 5
    override func prepareLayout() {
        super.prepareLayout()
        let itemW = (UIScreen.mainScreen().bounds.width - 3 * mairgn) / 2
        let itemH: CGFloat = 300
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5

    }
}
