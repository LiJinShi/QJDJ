//
//  QJDJCollectionCell_2.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJCollectionCell_2: UICollectionViewCell {

    // 第二种cell的属性
    @IBOutlet weak var goodsIcon_2: UIImageView!
    
    @IBOutlet weak var goodsIsSell_2: UILabel!
    
    @IBOutlet weak var goodsName_2: UILabel!
    
    @IBOutlet weak var goodsOriginalPrice_2: UILabel!
    
    @IBOutlet weak var goodsNowPrice_2: UILabel!
    
    
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

            
            goodsIcon_2.kf_setImageWithURL(url, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            

            
            goodsName_2.text = detailsModel?.GoodsName
            

            if detailsModel?.GoodsState == 0 {
                

                goodsIsSell_2.text = "待售"
            } else {
                

                
                goodsIsSell_2.text = "售完"
            }
            guard let originalPrice1 = detailsModel?.AttributePriceSCJ else {
                
                return
            }

            
            goodsOriginalPrice_2.text = "¥ "+String(originalPrice1)
            
            goodsOriginalPrice_2.textColor = UIColor.grayColor()
            guard let nowPrice1 = detailsModel?.AttributePriceCGJ else {
                
                return
            }
            

            
            goodsNowPrice_2.text = "¥ "+String(nowPrice1)
            goodsNowPrice_2.textColor = UIColor.orangeColor()
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
    }

}
