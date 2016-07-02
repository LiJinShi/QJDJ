//
//  QJDJDetailsNavRightItem.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/20.
//  Copyright © 2016年 LJS. All rights reserved.
//  商品详情列表导航条右边按钮

import UIKit
protocol PresentedProtol: class {
    func pushToNextVC () -> ()
}
class QJDJDetailsNavRightItem: UIView {
    
    lazy var btn: UIButton = {
    
       let btn = UIButton(type: .Custom)
            let norImage = ImageTool.OriginImage(UIImage(named: "goods_list_change_2")!, size: CGSize(width: 20, height: 20))
            let selectImage = ImageTool.OriginImage(UIImage(named: "goods_list_change_1")!, size: CGSize(width: 20, height: 20))
            btn.setImage(norImage, forState: .Normal)
            btn.setImage(selectImage, forState: .Selected)
            btn.sizeToFit()
            btn.adjustsImageWhenHighlighted = false
            btn.frame = CGRect(origin: CGPointZero, size: btn.currentImage!.size)
            btn.addTarget(self, action: #selector(QJDJDetailsNavRightItem.clickBtn), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    var pushBlock_1: (() -> ())?
    
    var pushBlock_2: (() -> ())?
    weak var presentedDelegate : PresentedProtol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickBtn() {
        
       btn.selected = !btn.selected
        if btn.selected == true {
        
            pushBlock_1!()
            
        } else {
        
            pushBlock_2!()
        }

    }
}
    

