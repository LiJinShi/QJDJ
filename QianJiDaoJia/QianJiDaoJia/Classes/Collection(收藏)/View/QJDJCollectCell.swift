//
//  QJDJCollectCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/23.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJCollectCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var SCJPrice: UILabel!
    @IBOutlet weak var status: UILabel!
    
    var collectItem: CollectShopItem? {
        willSet{
            guard let item = newValue else {return}
            imageV.kf_setImageWithURL(NSURL(string: item.GoodsThumbImg1!)!)
            title.text = item.GoodsName
            salePrice.text = "¥" + String(item.AttributePriceCGJ)
            SCJPrice.text = "¥" + String(item.AttributePriceSCJ)
            status.text = "待售"
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
