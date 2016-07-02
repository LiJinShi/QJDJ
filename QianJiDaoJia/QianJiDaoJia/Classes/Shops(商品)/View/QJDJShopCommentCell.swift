//
//  QJDJShopCommentCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/22.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJShopCommentCell: UITableViewCell {

    @IBOutlet weak var commnetLabel: UILabel!
    
    var shopItem: ShopItem? {
        willSet {
            guard let newItem = newValue else {return}
            commnetLabel.text = "商品评论(\(newItem.GoodsCommentCount)评价)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
