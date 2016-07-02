//
//  QJDJTabBar.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//  自定义tabBar,为了布局shopButton

import UIKit

protocol QJDJTabBarDelegate: NSObjectProtocol {
    func didShopButtonClick()
}

class QJDJTabBar: UITabBar {
    
    private lazy var shopButton: UIButton = {
        let shopButton = UIButton(type: .Custom)
        let image = UIImage(named: "cart_empty")
        shopButton.setBackgroundImage(image, forState: .Normal)
        shopButton.adjustsImageWhenHighlighted = false
        shopButton.bounds.size = CGSize(width: 43, height: 43)
        shopButton.addTarget(self, action: #selector(self.shopButtonClick), forControlEvents: .TouchUpInside)
        return shopButton
    }()
    
    weak var delegateForBtn: QJDJTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shopButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shopButton.center = CGPoint(x: self.bounds.width * 0.5 , y: self.bounds.height * 0.5 + 2)
    }

    // 监听按钮点击
    @objc private func shopButtonClick() {
        delegateForBtn?.didShopButtonClick()
    }
}

