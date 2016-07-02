//
//  QJDJFuncCollectionCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJFuncCollectionCell: UICollectionViewCell {

    private let titles: [String] = ["天天特惠", "热销排行", "新品尝鲜", "钱记专享", "味之缘", "收藏夹", "查订单", "领钱豆"]
    private let imageNames: [String] = ["shortcuts_icon_promotion", "shortcuts_icon_recharge", "shortcuts_icon_groupbuy", "shortcuts_icon_lottery", "shortcuts_icon_order", "shortcuts_icon_history", "shortcuts_icon_collect", "shortcuts_icon_life_journey"]
    
    var index: Int = 0 {
        willSet(newIndex) {
            imageV.image = UIImage(named: imageNames[newIndex])
            imageV.sizeToFit()
            label.text = titles[newIndex]
        }
    }
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
