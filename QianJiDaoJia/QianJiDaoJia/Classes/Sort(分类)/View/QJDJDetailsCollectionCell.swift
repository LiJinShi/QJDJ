//
//  QJDJDetailsCollectionCell.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJDetailsCollectionCell: UICollectionViewCell {
    
    // 第一种cell的属性
    @IBOutlet weak var goodsIcon_1: UIImageView!
    
    @IBOutlet weak var goodsName_1: UILabel!
    
    @IBOutlet weak var goodsDescribe_1: UILabel!
    
    @IBOutlet weak var goodsIsSell_1: UILabel!
    
    @IBOutlet weak var goodsNowPrice_1: UILabel!
    
    @IBOutlet weak var goodsOriginalPrice_1: UILabel!
    
    
    
    // 重写模型的set方法
    var detailsModel: QJDJDetailsModel? {
        
        didSet {
            
            // 图片
            guard let str: String = detailsModel?.GoodsThumbImg1 else {
                
                return
            }
            
            guard let url = NSURL(string: str) else {
                
                return
            }
            let placeHolderImage = UIImage(named: "ic_launcher")
            goodsIcon_1.kf_setImageWithURL(url, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
            goodsName_1.text = detailsModel?.GoodsName
        
            goodsDescribe_1.text = detailsModel?.GoodsSlogan
            goodsDescribe_1.textColor = UIColor(red: 0.0, green: 166/255.0, blue: 83/255.0, alpha: 1)
            if detailsModel?.GoodsState == 0 {
                
                goodsIsSell_1.text = "待售"

            } else {
                
                goodsIsSell_1.text = "售完"

            }
            guard let originalPrice1 = detailsModel?.AttributePriceSCJ else {
                
                return
            }
            goodsOriginalPrice_1.text = "¥ "+String(originalPrice1)
            goodsOriginalPrice_1.textColor = UIColor.grayColor()
            

            guard let nowPrice1 = detailsModel?.AttributePriceCGJ else {
                
                return
            }
            
            goodsNowPrice_1.text = "¥ "+String(nowPrice1)
            goodsNowPrice_1.textColor = UIColor.orangeColor()
            

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .None
        backgroundColor = UIColor.whiteColor()
    }

}
