//
//  QJDJLabelBanner.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SDCycleScrollView

class QJDJLabelBanner: UIView, SDCycleScrollViewDelegate {  

    private var emojArr: [String] = { // 设置几个表情玩一玩
        return ["😂", "😬", "😳", "😀", "👀", "😎", "✍🏻"]
    }()
    var textArr: [String]? {
        willSet {
            guard let newTextArr = newValue else {return}
            // 根据颜色生成几张背景图上
            let color = UIColor(red: 39/255.0, green: 42/255.0, blue: 44/255.0, alpha: 0.7)
            let image = ImageTool.creatImageWithColor(color, size: self.size) // 根据颜色生成图片
            var imageArr = [UIImage]()
            let textArrCount = newTextArr.count
            let emojArrCount = self.emojArr.count
            for i in 0..<newTextArr.count {
                let text = (textArrCount > emojArrCount ? self.emojArr[textArrCount - i] : self.emojArr[i]) + newTextArr[i]
                let newImage = image.addText(image, text: text, atPoint: CGPoint(x: 20, y: 1.5))
                imageArr.append(newImage)
            }
            banner.localizationImageNamesGroup = imageArr
        }
    }
    
    // get方法懒加载文字轮播器
    private lazy var banner: SDCycleScrollView = {
        let scrollW: CGFloat = self.bounds.width
        let scrollH: CGFloat = self.bounds.height
        let rect = CGRect(x: 0, y: 0, width: scrollW, height: scrollH)
        let banner: SDCycleScrollView = SDCycleScrollView(frame: rect, delegate: nil, placeholderImage: nil)
        banner.userInteractionEnabled = true
        banner.autoScrollTimeInterval = 3 // 每3秒轮播一下(默认为2秒)
        banner.scrollDirection = .Vertical // 滚动方向-垂直
        banner.showPageControl = false // 不显示分页控件 
        let collectV: UICollectionView = banner.subviews[1] as! UICollectionView
        collectV.scrollsToTop = false // 取出轮播器里的子控件，禁用掉这个属性
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
