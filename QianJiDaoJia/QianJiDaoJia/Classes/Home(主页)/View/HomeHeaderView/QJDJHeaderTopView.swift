//
//  QJDJTopView.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SDCycleScrollView
import MJExtension

protocol QJDJHeaderTopViewDelegate: NSObjectProtocol {
    func touchBannerImageView(categoryID: Int)
}

class QJDJHeaderTopView: UIView {
    
    weak var delegate: QJDJHeaderTopViewDelegate?
    // 懒加载模型
    var bannerItems = [BannerViewItem]()
    // 图片数组
    var imageUrlArr: [String]? {
        willSet {
            banner.imageURLStringsGroup = newValue
        }
    }
    
    // 轮播器get方法懒加载
    private lazy var banner: SDCycleScrollView = {
        let scrollW: CGFloat = self.bounds.width
        let scrollH: CGFloat = self.bounds.height
        let rect = CGRect(x: 0, y: 0, width: scrollW, height: scrollH)
        let banner: SDCycleScrollView = SDCycleScrollView(frame: rect, delegate: nil, placeholderImage: nil)
        banner.userInteractionEnabled = true
        banner.delegate = self
        let collectV: UICollectionView = banner.subviews[1] as! UICollectionView
        collectV.scrollsToTop = false // 取出这个子控件，禁用掉它的这个属性
        return banner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(banner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    

extension QJDJHeaderTopView: SDCycleScrollViewDelegate {
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        if index == 1 { // 第二张图片(跑到调查问卷)
            print("要跳转调查问卷页面")
        } else {
            delegate?.touchBannerImageView(Int(bannerItems[index].BannerValue!)!)
        }
    }
}
