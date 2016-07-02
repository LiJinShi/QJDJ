//
//  QJDJInfoCell.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//  分类右边第一个cell

import UIKit

class QJDJInfoCell: UITableViewCell {

    @IBOutlet weak var infoNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    
    
    /**
     开始返回infocell
     
     - parameter tableview: 传入一个tableView
     
     - returns: 返回cell
     */
    class func cellWithTableView(tableview: UITableView) -> QJDJInfoCell {
        
        let cellID = "infocell"
        var cell = tableview.dequeueReusableCellWithIdentifier(cellID) as? QJDJInfoCell
        if cell == nil {
            
            cell = NSBundle.mainBundle().loadNibNamed("QJDJInfoCell", owner: nil, options: nil).first as? QJDJInfoCell
        }
        
        return cell!
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
