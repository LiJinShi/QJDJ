//
//  ShopMessageItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class ShopMessageItem: NSObject {
    var AttributeId: Int = 0 // 商品ID
    var AttributeName: String? // 商品单位重量
    var AttributePriceCGJ: Int = 0 // 商品单价
    var AttributePriceSCJ: Int = 0 // 市场价
    var AttributePriceText: String? // 市场价后的单位
    
    // 没用到
    var AttributeStock: Int = 0
    var AttributeWeight: Int = 0
}
