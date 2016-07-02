//
//  QJDJSquareModel.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//  分类右边下部model

import UIKit

class QJDJSquareModel: NSObject {

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
