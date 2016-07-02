//
//  ShopItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import MJExtension

class ShopItem: NSObject {
    
    var GoodsPicList: [String]? // 顶部轮播图片（url）
    var GoodsName: String? // 商品名
    var GoodsSlogan: String? // 宣传标语，类似“新品上市，放心实惠。”
    
    var GoodsAttributeList: [ShopMessageItem]? // 模型内又有数组模型
    
    var GoodsBrand: String? // 商品品牌
    var GoodsCommentCount: Int = 0 // 商品评论数
    var GoodsCommentLevel: Int = 0 // 商品评论等级
    
    var GoodsContentDetail: String? // 商品详情（一个HTML网页）
    var GoodsDistribution: String? // 商品提示配送范围等
    var GoodsId: Int = 0 // 商品ID
    var GoodsNumber: Int = 0 // 商品编号
    var GoodsSourceArea: String? // 商品产地
    var GoodsReminder: String? // 钱记到家声明
    var GoodsSalesVolume: Int = 0 // 已经售出数量
    var GoodsServiceMode: String? // 服务（这个数据的处理:str.componentsSeparatedByString(",")然后生成一个数组）
    var GoodsStoreMode: String? // 商品存储
    
    var GoodsState: Int = 0 // 这个暂不知什么意思
    var GoodsTagText: String? // 不知
    
    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["GoodsAttributeList" : ShopMessageItem.classForCoder()]
    }
    
}
