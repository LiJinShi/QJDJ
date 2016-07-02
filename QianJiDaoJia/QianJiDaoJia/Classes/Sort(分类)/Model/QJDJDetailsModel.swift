//
//  QJDJDetailsModel.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//  详情界面model

import UIKit

class QJDJDetailsModel: NSObject {

    /// 商品ID
    var GoodsId: Int = 0
    /// 属性名
    var AttributeName: String?
    /// 商品名
    var GoodsName: String?
    /// 商品图片url
    var GoodsThumbImg1: String?
    /// 商品介绍
    var GoodsSlogan: String?
    /// 商品状态
    var GoodsState: Int = 0
    var GoodsTagText: String?
    var AttributeId: Int = 0
    /// 折扣价
    var AttributePriceCGJ: Int = 0
    /// 原价
    var AttributePriceSCJ: Int = 0
    var AttributeStock: Int = 0
    var GoodsInDistribution: Int = 0
    
    // 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 容错处理,防止属性不匹配
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

    
}
