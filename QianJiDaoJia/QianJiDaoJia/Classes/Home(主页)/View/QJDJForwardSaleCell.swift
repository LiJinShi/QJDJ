//
//  QJDJForwardSaleCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import Kingfisher

class QJDJForwardSaleCell: UICollectionViewCell {

    @IBOutlet weak var imaegV: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    // 模型
    var item: ForwardSaleItem? {
        willSet(newItem) { // 属性监听
            title.text = newItem?.GoodsName
            imaegV.kf_setImageWithURL(NSURL(string: (newItem?.GoodsThumbImg1)!)!)
            imaegV.userInteractionEnabled = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
