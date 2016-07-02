//
//  ForwardSaleItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/19.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class ForwardSaleItem: NSObject {
    // 定义模型属性
    var GoodsName: String = "" // 商品标题
    var GoodsThumbImg1: String = "" // 商品图片url
    var GoodsId: Int = 0 // 商品的ID,点击cell时跳转到商品控制器发数据就是根据这个id来拼接参数
}
