//
//  QJDJCategoryModel.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//
// 这里可以用适配器模式
// 分类左边model
import UIKit

class QJDJCategoryModel: NSObject {

    var CategoryName: String?
    
    var CategoryImg: String?
    
    var CategoryId: Int = 0
    
    // 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 容错处理,防止属性不匹配
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
