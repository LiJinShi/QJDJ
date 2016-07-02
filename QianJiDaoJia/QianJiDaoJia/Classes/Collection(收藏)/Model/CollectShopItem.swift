//
//  CollectShopItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/23.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class CollectShopItem: NSObject {
    /*
     
     "GoodsState" : 0,
     "AttributeStock" : 0,
     "AttributeId" : 46,
     "GoodsTagText" : "000000000",
     "GoodsThumbImg1" : "http:\/\/bmworld.cn:1234\/upload\/goods\/aila60g\/thumb1.png",
     "AttributeName" : "60g",
     "AttributePriceCGJ" : 8,
     "GoodsInDistribution" : 1,
     "AttributePriceSCJ" : 8.5,
     "GoodsSlogan" : "",
     "GoodsId" : 46,
     "GoodsName" : "无穷盐焗鸡翅 爱辣鸡翅(铝膜)  60g"
     
     */
    
    
    var GoodsState: Int = 0
    var AttributeStock: Int = 0
    var AttributeId: Int = 0
    var GoodsTagText: String?
    var GoodsThumbImg1: String?
    var AttributeName: String?
    var AttributePriceCGJ: CGFloat = 0
    var GoodsInDistribution: Int = 0
    var AttributePriceSCJ: CGFloat = 0
    var GoodsSlogan: String?
    var GoodsId: Int = 0
    var GoodsName: String?
}
