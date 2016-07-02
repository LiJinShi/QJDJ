//
//  QJDJDiscoveryCell.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/20.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJDiscoveryCell: UICollectionViewCell {
    // 现价
    @IBOutlet weak var disNowPrice: UILabel!
    // 商品图片
    @IBOutlet weak var disGoodsImageView: UIImageView!
    // 是否有售
    @IBOutlet weak var disIsSell: UILabel!
    // 商品名
    @IBOutlet weak var disGoodsName: UILabel!
    // 原价
    @IBOutlet weak var originalPrice: UILabel!
    
    var detailsModel: QJDJDetailsModel? {
        didSet  {
            // 图片
            guard let str: String = detailsModel?.GoodsThumbImg1 else {
                return
            }
            guard let url = NSURL(string: str) else {
                return
            }
            let placeHolderImage = UIImage(named: "ic_launcher")
            disGoodsImageView.kf_setImageWithURL(url, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            disGoodsName.text = detailsModel?.GoodsName
            if detailsModel?.GoodsState == 0 {
                disIsSell.text = "待售"
            } else {
                disIsSell.text = "售完"
            }
            guard let originalPrice1 = detailsModel?.AttributePriceSCJ else {
                return
            }
            originalPrice.text = "¥ "+String(originalPrice1)
            originalPrice.textColor = UIColor.grayColor()
            guard let nowPrice1 = detailsModel?.AttributePriceCGJ else {
                return
            }
            disNowPrice.text = "¥ "+String(nowPrice1)
            disNowPrice.textColor = UIColor.orangeColor()
        }
}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
