//
//  QJDJNoDetailsModelView.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/22.
//  Copyright © 2016年 LJS. All rights reserved.
// 没有数据时展示的view

import UIKit
import SDAutoLayout
class QJDJNoDetailsModelView: UIView {


    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shopping_cart_empty_cart")
        return imageView
    }()
    
    lazy var labelText: UILabel = {
        let labelText = UILabel()
        labelText.text = "抱歉,没有找到商品"
        labelText.textAlignment = .Center
        return labelText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(labelText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.sd_layout()
        .widthIs(200)
        .heightIs(200)
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        labelText.sd_layout()
        .widthIs(200)
        .heightIs(20)
        .topSpaceToView(self.imageView, 10)
        .centerXEqualToView(self.imageView)
    }
    
}
