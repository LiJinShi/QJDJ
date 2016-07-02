//
//  QJDJCategoryCell.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//  分类左边的cell

import UIKit
import Kingfisher
class QJDJCategoryCell: UITableViewCell {
    

    @IBOutlet weak var categoryIconImageView: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    
    var categoryModel: QJDJCategoryModel? {
        
        didSet {
            
            categoryNameLabel.text = categoryModel?.CategoryName
            
            guard let str: String = categoryModel?.CategoryImg else {
            
                return
            
            }
            guard let url = NSURL(string: str) else {
            
                return
            }
            let placeHolderImage = UIImage(named: "ic_launcher")
            categoryIconImageView.kf_setImageWithURL(url, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    /**
     获取自定义的cell
     
     - parameter tableview: 传入一个tableView
     
     - returns: 自定义的cell
     */
    class func cellWithTableView(tableview: UITableView) -> QJDJCategoryCell {
    
        let cellID = "categoryCell"
        var cell = tableview.dequeueReusableCellWithIdentifier(cellID) as? QJDJCategoryCell
        if cell == nil {
        
            cell = NSBundle.mainBundle().loadNibNamed("QJDJCategoryCell", owner: nil, options: nil).first as? QJDJCategoryCell
            cell?.backgroundColor = UIColor.lightGrayColor()
        }
        
        return cell!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // 取消选中样式
        //selectionStyle = UITableViewCellSelectionStyle.None
        
        categoryIconImageView.layer.cornerRadius = 0.5 * categoryIconImageView.bounds.width

        
    }
    
    // 取消高亮
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.backgroundColor = UIColor.whiteColor()
            categoryNameLabel.textColor = UIColor(red: 0.0, green: 166/255.0, blue: 83/255.0, alpha: 1)
            
        } else {
            self.backgroundColor = UIColor.lightGrayColor()
            categoryNameLabel.textColor = UIColor.blackColor()
            
        }
        
        

    }
    
}
