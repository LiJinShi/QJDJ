//
//  QJDJCell.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import Kingfisher

protocol QJDJCellDelegate: NSObjectProtocol {
    func didselectOneCellImage(picItem: PicItem)
}


class QJDJCell: UITableViewCell {

    weak var delegate: QJDJCellDelegate?
    
    lazy var imageV: UIImageView = {
        let imageV = UIImageView()
        imageV.frame = CGRect(x: 0, y: 0, width:  HomeItem.shareHomeItem.topViewW, height: HomeItem.shareHomeItem.bottomCellH)
        imageV.userInteractionEnabled = true
        self.contentView.addSubview(imageV)
        return imageV
    }()
    
    var picItem: PicItem? = nil {
        willSet(newItem) {
            guard let item = newItem else {return}
            imageV.kf_setImageWithURL(NSURL(string: item.Path!)!)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        backgroundColor = UIColor.lightGrayColor()
        addGestureForImageVeiw() // 给imageView添加手势
    }
    
    // 给imageView添加手势
    private func addGestureForImageVeiw() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didselectedImageV))
        imageV.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        willSet{
            super.frame.origin.y += 2
        }
    }
}

// MARK: -监听图片点击
extension QJDJCell {
    // 监听图片的点击
    @objc private func didselectedImageV() {
        delegate?.didselectOneCellImage(picItem!) // 将cell的模型传递出去
    }
}
