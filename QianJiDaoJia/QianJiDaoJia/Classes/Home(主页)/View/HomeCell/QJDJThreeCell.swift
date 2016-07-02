//
//  QJDJThreeCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/20.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import Kingfisher
protocol QJDJThreeCellDelegate: NSObjectProtocol {
    func didselectThreeCellLeftTopImage(goodsID: Int)
    func didselecThreeCellBottomImage(goodsID: Int)
    func didselectThreeCellRightImage(goodsID: Int)
}


class QJDJThreeCell: UITableViewCell {

    @IBOutlet weak var leftTopImageV: UIImageView!
    @IBOutlet weak var leftBottomImageV: UIImageView!
    @IBOutlet weak var rightImageV: UIImageView!
    
    weak var delegate: QJDJThreeCellDelegate?
    
    // 这个cell里有3张图,从外面传一个模型数组进来
    var picItems: [PicItem]? {
        willSet(new) {
            guard let newArr = new else {return}
            
            let urlStr1 = newArr[0].Path
            leftTopImageV.kf_setImageWithURL(NSURL(string: urlStr1!)!)
            
            let urlStr2 = newArr[1].Path
            leftBottomImageV.kf_setImageWithURL(NSURL(string: urlStr2!)!)
            
            let urlStr3 = newArr[2].Path
            rightImageV.kf_setImageWithURL(NSURL(string: urlStr3!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        
        backgroundColor = UIColor.lightGrayColor()
        addGestureForImageVeiw() // 给imageView添加手势
    }
    
    // 给imageView添加手势
    private func addGestureForImageVeiw() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.didselectedLeftTopImage))
        leftTopImageV.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.didselectedLeftBottomImage))
        leftBottomImageV.addGestureRecognizer(tap2)
        
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

// MARK: -监听图片点击
extension QJDJThreeCell {
    // 点击了这个cell左上角图片
    @objc private func didselectedLeftTopImage() {
        
        let goodsID: Int = Int((picItems?.first?.Value)!)!
        delegate?.didselectThreeCellLeftTopImage(goodsID)
    }
    
    // 点击了这个cell左下角图片
    @objc private func didselectedLeftBottomImage() {

        let goodsID: Int = Int((picItems![1] as PicItem).Value!)!
        delegate?.didselecThreeCellBottomImage(goodsID)
    }
    
    // 点击了右边图片
    @objc private func didselectedRightImage() {
        let goodsID: Int = Int((picItems?.last?.Value)!)!
        delegate?.didselectThreeCellRightImage(goodsID)
    }
}
