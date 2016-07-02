//
//  QJDJInfoSquareViewCell.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//  分类右边下面cell

import UIKit

class QJDJInfoSquareViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    var squareModel: QJDJSquareModel? {
        
        didSet {
            
            nameLabel.text = squareModel?.CategoryName
            
            guard let str: String = squareModel?.CategoryImg else {
                
                return
                
            }
            guard let url = NSURL(string: str) else {
                
                return
            }
            let placeHolderImage = UIImage(named: "ic_launcher")
            iconImageView.kf_setImageWithURL(url, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    // 取消高亮
}


