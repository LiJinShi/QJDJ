//
//  QJDJShopHeaderView.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SwiftyJSON

class QJDJShopHeaderView: UIView {

    @IBOutlet weak var topBannerView: UIView! // 顶部图片轮播view
    @IBOutlet weak var goodNameLabel: UILabel! // 商品名
    @IBOutlet weak var goodSloganLabel: UILabel! // 商品宣传
    @IBOutlet weak var siglePriceLabel: UILabel! // 单价
    @IBOutlet weak var siglePriceUnitsLabel: UILabel! // 单价后单位
    @IBOutlet weak var shopSCJLabel: UILabel! // 市场价
    @IBOutlet weak var shopsSCJUnitsLabel: UILabel! // 市场价后的单位
    
    @IBOutlet weak var saleNumberLabel: UILabel! // 售出商品数量
    @IBOutlet weak var weightLabel: UILabel! // 商品规格（多重）
    @IBOutlet weak var goodsNumber: UILabel! // 商品编号
    @IBOutlet weak var sourceAreaLabel: UILabel! // 商品产地
    @IBOutlet weak var storeModelLabel: UILabel! // 存储方式
    @IBOutlet weak var shopBrandLabel: UILabel! // 商品品牌
    
    // 这两数据用逗号分开，然后得到数组再往里放
    @IBOutlet weak var serivce1Label: UILabel! 
    @IBOutlet weak var serivce2Label: UILabel!
    
    @IBOutlet weak var dstributiondLabel: UILabel! // 商品描述：配送区域
    @IBOutlet weak var reminderLabel: UILabel! // 钱记到家声明
    
    @IBOutlet weak var shopMessageView: UIView!
    
    private lazy var topBanner: SDCycleScrollView = {
        let scrollW: CGFloat = self.bounds.width
        let scrollH: CGFloat = self.topBannerView.bounds.height
        let rect = CGRect(x: 0, y: 0, width: scrollW, height: scrollH)
        let banner: SDCycleScrollView = SDCycleScrollView(frame: rect, delegate: nil, placeholderImage: nil)
        banner.userInteractionEnabled = true // 允许用户交互，可不写
        banner.autoScroll = false // 不自动滚动
        banner.currentPageDotColor = UIColor.greenColor()
        self.topBannerView.addSubview(banner)
        return banner
    }()
    
    var shopItem: ShopItem? { // 外层模型
        willSet {
            guard let newItem = newValue else {return}
            topBanner.imageURLStringsGroup = newItem.GoodsPicList // 轮播图片url
            goodNameLabel.text = newItem.GoodsName
            goodSloganLabel.text = newItem.GoodsSlogan
            saleNumberLabel.text = String(newItem.GoodsSalesVolume)
            goodsNumber.text = String(newItem.GoodsNumber)
            sourceAreaLabel.text = newItem.GoodsSourceArea
            storeModelLabel.text = newItem.GoodsStoreMode
            shopBrandLabel.text = newItem.GoodsBrand
            
            let arr = newItem.GoodsServiceMode?.componentsSeparatedByString(",")
            serivce1Label.text = arr![0]
            serivce2Label.text = arr![1]
        }
    }
    
    var goodsItem: ShopMessageItem? { // 内层模型
        willSet {
            guard let newItem = newValue else {return}
            
            siglePriceLabel.text = String(newItem.AttributePriceCGJ) // 单价
            siglePriceUnitsLabel.text = newItem.AttributePriceText // 单价单位
            shopSCJLabel.text = String(newItem.AttributePriceSCJ) // 市场价
            shopsSCJUnitsLabel.text = newItem.AttributePriceText // 市场价单位
            weightLabel.text = newItem.AttributeName
        }
    }
    
    // 快速从xib加载
    class func viewFromNib() -> QJDJShopHeaderView {
        return NSBundle.mainBundle().loadNibNamed("QJDJShopHeaderView", owner: nil, options: nil).first as! QJDJShopHeaderView
    }

    override func awakeFromNib() {
        autoresizingMask = .None // 防止从xib加载出来被拉伸
    }
    
//    // 计算label内文字的高度（这里没用上）
//    func CalculatorSelfHeight(getHeight: (height: CGFloat) -> ()) {
//        
//        let text1 = dstributiondLabel.text!
//        let size1 = CGSize(width: dstributiondLabel.width, height: 900)
//        var dict1 = [String: NSObject]()
//        dict1[NSFontAttributeName] = UIFont.systemFontOfSize(13)
//        let textHeight1 = text1.boundingRectWithSize(size1, options: .UsesFontLeading, attributes: dict1, context: nil).height
//        
//        let text2 = reminderLabel.text!
//        let size2 = CGSize(width: reminderLabel.width, height: 900)
//        var dict2 = [String: NSObject]()
//        dict2[NSFontAttributeName] = UIFont.systemFontOfSize(13)
//        let textHeight2 = text2.boundingRectWithSize(size2, options: .UsesFontLeading, attributes: dict2, context: nil).height 
//        
//        // 返回内部view的总高度
//        let height = CGRectGetMaxY(shopMessageView.frame) + 10 + textHeight1 + 15 + textHeight2 + 10
//        getHeight(height: height)
//    }
    
    
}
