//
//  QJDJTwoCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/20.
//  Copyright © 2016年 LJS. All rights reserved.
//  序号为2的那个cell（显示的是三张竖图）

import UIKit

protocol QJDJTwoCellDelegate: NSObjectProtocol {
    func didselectTwoCellLeftImage(categoryID: Int, title: String)
    func didselectTwoCellMiddleImage(categoryID: Int, title: String)
    func didselectTwoCellRightImage(categoryID: Int, title: String)
}
class QJDJTwoCell: UITableViewCell {

    @IBOutlet weak var leftImageV: UIImageView!
    @IBOutlet weak var middleImageV: UIImageView!
    @IBOutlet weak var rightImageV: UIImageView!
    
    weak var delegate: QJDJTwoCellDelegate?
    
    // 这个cell里有3张图,从外面传一个模型数组进来,对控件数据进行设置
    var picItems: [PicItem]? {
        willSet(new) {
            guard let newArr = new else {return}
            
            let urlStr1 = newArr[0].Path
            leftImageV.kf_setImageWithURL(NSURL(string: urlStr1!)!)
            
            let urlStr2 = newArr[1].Path
            middleImageV.kf_setImageWithURL(NSURL(string: urlStr2!)!)
            
            let urlStr3 = newArr[2].Path
            rightImageV.kf_setImageWithURL(NSURL(string: urlStr3!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        
        backgroundColor = UIColor.lightGrayColor()
        addGestureForImageVeiw() // 给imageView添加点击手势
    }

    // 给imageView添加点击手势
    private func addGestureForImageVeiw() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.didselectedLeftImage))
        leftImageV.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.didselectedMiddleImage))
        middleImageV.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.didselectedRightImage))
        rightImageV.addGestureRecognizer(tap3)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override var frame: CGRect {
        willSet{
            super.frame.origin.y += 2
        }
    }
}

// MARK:- 监听cell内图片的点击
extension QJDJTwoCell {
    // 点击了左图
    @objc private func didselectedLeftImage() {
        let categoryID = Int((picItems?.first?.Value)!)
        let title = picItems?.first?.Title
        delegate?.didselectTwoCellLeftImage(categoryID!, title: title!)
    }
    
    // 点击了中间图片
    @objc private func didselectedMiddleImage() {
        let categoryID = Int((picItems![1] as PicItem).Value!)
        let title = (picItems![1] as PicItem).Title
        delegate?.didselectTwoCellMiddleImage(categoryID!, title: title!)
    }
    
    // 点击了右边图片
    @objc private func didselectedRightImage() {
        let categoryID = Int((picItems?.last?.Value)!)
        let title = picItems?.first?.Title
        delegate?.didselectTwoCellRightImage(categoryID!, title: title!)
    }
}
